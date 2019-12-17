import UIKit
class SettingsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var refreshOnStartToggle: UISwitch!
    @IBOutlet weak var priceSelector: UIView!
    @IBOutlet weak var selectedMensaName: UILabel!
    @IBOutlet weak var mensaPicker: UIPickerView!
    @IBOutlet weak var mensaNameCell: UITableViewCell!
    @IBOutlet weak var mensaPickerCell: UITableViewCell!
    @IBOutlet weak var pricePicker: UISegmentedControl!
    @IBOutlet weak var appVersionCell: UITableViewCell!
    @IBOutlet weak var appSupportCell: UITableViewCell!
    @IBOutlet weak var appStoreCell: UITableViewCell!
    @IBOutlet weak var rateAppCell: UITableViewCell!
    @IBOutlet weak var developerCell: UITableViewCell!
    var isPickerHidden = true
    var selectedMensa : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        mensaPicker.delegate = self
        mensaPicker.dataSource = self
        setupView()
    }
    func setupView() {
        let isSetup  = CanteenplanApp.sharedDefaults.bool(forKey: LocalKeys.isSetup)
        if isSetup {
            refreshOnStartToggle.isOn = CanteenplanApp.sharedDefaults.bool(forKey: LocalKeys.refreshOnStart)
            guard let selectedPrice = CanteenplanApp.sharedDefaults.string(forKey: LocalKeys.selectedPrice) else {
                return
            }
            pricePicker.selectedSegmentIndex = CanteenplanApp.priceValues.firstIndex(of: selectedPrice)!
            let selectedMensaValue = CanteenplanApp.sharedDefaults.string(forKey: LocalKeys.selectedMensa)!
            let selectedMensaValueIndex = CanteenplanApp.standorteKeys.firstIndex(of: selectedMensaValue)!
            selectedMensaName.text = CanteenplanApp.standorteValues[selectedMensaValueIndex]
            mensaPicker.selectRow(selectedMensaValueIndex, inComponent: 0, animated: false)
            appVersionCell.detailTextLabel?.text = CanteenplanApp.versionString
        }
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
        }
        if #available(iOS 13.0, *) {
            navigationController?.isModalInPresentation = true
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CanteenplanApp.standorteKeys.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CanteenplanApp.standorteValues[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMensa = CanteenplanApp.standorteKeys[row]
        selectedMensaName.text = CanteenplanApp.standorteValues[row]
        CanteenplanApp.sharedDefaults.set(selectedMensa, forKey: LocalKeys.selectedMensa)
    }
    @IBAction func setRefreshOnStart(_ sender: Any) {
        CanteenplanApp.sharedDefaults.set(refreshOnStartToggle.isOn, forKey: LocalKeys.refreshOnStart)
    }
    @IBAction func priceSelection(_ sender: Any) {
        let selectedIndex = pricePicker.selectedSegmentIndex
        let priceValue = CanteenplanApp.priceValues[selectedIndex]
        CanteenplanApp.sharedDefaults.set(priceValue, forKey: LocalKeys.selectedPrice)
    }
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "unwindToMain", sender: sender)
    }
    func appStoreAction() {
        let urlStr = "itms-apps://itunes.apple.com/app/id\(CanteenplanApp.appStoreId)"
        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
