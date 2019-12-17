import Foundation
import MessageUI
import UIKit
extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func sendSupportMail() {
//        #if targetEnvironment(macCatalyst)
//        let message = NSLocalizedString("mac_support_message", comment: "")
//        showMessage(title: NSLocalizedString("mac_support_header", comment: ""), message: String(format: message, CanteenplanApp.mailAdress), on: self)
//        #else
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("[Canteenplan] - Version \(CanteenplanApp.versionString) (Build: \(CanteenplanApp.buildNumber))")
            mail.setToRecipients([CanteenplanApp.mailAdress])
            mail.setMessageBody(NSLocalizedString("support_mail_body", comment: ""), isHTML: false)
            present(mail, animated: true)
        } else {
            print("No mail account configured")
            let mailErrorMessage = NSLocalizedString("mail_no_account_error", comment: "")
            showMessage(title: NSLocalizedString("error_title", comment: ""), message: String(format: mailErrorMessage, CanteenplanApp.mailAdress), on: self)
        }
//        #endif
        // - \(getReleaseTitle())
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
