import Foundation
import UIKit
import StoreKit
extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 3 {
            return isPickerHidden ? 0 : 165
        }
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         guard let header = view as? UITableViewHeaderFooterView else { return }
           header.textLabel?.textColor = UIColor.white
    }
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
         guard let header = view as? UITableViewHeaderFooterView else { return }
           header.textLabel?.textColor = UIColor.white
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "Build Nummer: \(CanteenplanApp.buildNumber) "
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        switch (selectedCell) {
        case mensaNameCell:
            isPickerHidden = !isPickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
            break
        case appSupportCell:
            sendSupportMail()
            break
        case rateAppCell:
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
            }
            break
        case appStoreCell:
            appStoreAction()
            break
        case developerCell:
            openSafariViewControllerWith(url: CanteenplanApp.website)
            break
        default:
            break
        }
    }
}
