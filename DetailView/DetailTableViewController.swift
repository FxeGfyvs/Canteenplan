import UIKit
class DetailTableViewController: UITableViewController {
    var mensaPlanDay: MensaplanDay?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mensaPlanDay = mensaPlanDay else {
            return
        }
        title = getDayName(by: mensaPlanDay.getDateValue())
        if mensaPlanDay.isToday() {
            setupTodayIntent()
        } else if mensaPlanDay.isTomorrow() {
            setupTomorrowIntent()
        }
    }
    func setupTodayIntent() {
        let activity = NSUserActivity(activityType: Shortcuts.showToday) 
        activity.title = "Mensaplan für heute anzeigen" 
        activity.userInfo = ["speech" : "show plan for today"] 
        activity.isEligibleForSearch = true 
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(Shortcuts.showToday)
        }
        view.userActivity = activity 
        activity.becomeCurrent() 
    }
    func setupTomorrowIntent() {
        let activity = NSUserActivity(activityType: Shortcuts.showTomorrow) 
        activity.title = "Mensaplan für morgen anzeigen" 
        activity.userInfo = ["speech" : "show plan for tomorrow"] 
        activity.isEligibleForSearch = true 
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(Shortcuts.showTomorrow)
        }
        view.userActivity = activity 
        activity.becomeCurrent() 
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMealSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let meal = mensaPlanDay!.counters[indexPath.section].meals[indexPath.row]
                let vc = segue.destination as! MealViewController
                vc.meal = meal
            } else {
                print("Oops, no row has been selected")
            }
        }
    }
}
