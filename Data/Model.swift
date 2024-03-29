import Foundation
struct LocalKeys {
    static let isSetup = "isSetup"
    static let refreshOnStart = "refreshOnStart"
    static let selectedPrice = "selectedPrice"
    static let selectedMensa = "selectedMensa"
    static let lastUpdate = "lastUpdate"
    static let jsonData = "jsonData"
}
struct Shortcuts {
    static let showToday = "de.marc-hein.mensaplan.showToday"
    static let showTomorrow = "de.marc-hein.mensaplan.showTomorrow"
}
enum DayValue {
    case TODAY
    case TOMORROW
}
struct CanteenplanApp {
    static let standorteValues = ["Mensa Tarforst", "Bistro A/B", "Mensa Petrisberg", "Mensa Schneidershof", "Mensa Irminenfreihof" ,"forU"]
    static let standorteKeys = ["standort-1","standort-2","standort-3","standort-4","standort-5","standort-7"]
    static let standorteOpenings: [Opening] = [
        Opening(semester: "1. Untergeschoss:\nMo.-Do. 11.15 Uhr bis 13.45 Uhr\nFr. 11.15 Uhr bis 13.30 Uhr\n\n2. Untergeschoss:\nMo.-Do. 11.15 Uhr bis 14.15 Uhr", semesterFerien: "Mo.-Fr. 11.30 Uhr bis 13.30 Uhr"),
        Opening(semester: "Mo.-Do. 07.45 Uhr bis 19.30 Uhr\nFr. 07.45 Uhr bis 16.30 Uhr\nSa. 08.45 Uhr bis 13.30 Uhr\n\nAbendmensa: Mo.-Do. 17.30 Uhr bis 19.00 Uhr\n\nSamstagsmensa: 11.30 Uhr bis 13.30 Uhr\n\nPASTA-THEKE: Mo.-Do. 11.30 Uhr bis 14.30 Uhr\nFreitag 11.30 Uhr bis 14.00 Uhr ", semesterFerien: "Mo.-Fr. 08.30 Uhr bis 16.30 Uhr\n\nPASTA-THEKE: Mo.-Do. 11.30 Uhr bis 14.30 Uhr\nFreitag 11.30 Uhr bis 14.00 Uhr"),
        Opening(semester: "Mo.-Do. 11.30 Uhr bis 13.45 Uhr\nFr. 11.30 Uhr bis 13.30 Uhr", semesterFerien: "Mo.-Fr. 11.30 Uhr bis 13.30 Uhr"),
        Opening(semester: "Mo.-Do. 11.15 Uhr bis 13.45 Uhr\nFr. 11.15 Uhr bis 13.30 Uhr", semesterFerien: "Mo.-Fr. 11.30 Uhr bis 13.30 Uhr"),
        Opening(semester: "Mo.-Do. 11.30 Uhr bis 13.45 Uhr\nFr. 11.30 Uhr bis 13.30 Uhr", semesterFerien: "In den Semesterferien ist die Mensa am Irminenfreihof geschlossen."),
        Opening(semester: "Mo.-Do. 08.00 Uhr bis 16.15 Uhr\nFr. 08.00 Uhr bis 14.45 Uhr", semesterFerien: "Mo.-Do. 08.00 Uhr bis 15.30 Uhr\nFr. 08.00 Uhr bis 14.45 Uhr")
    ]
    static let priceValues = ["student", "worker", "guest"]
    static let STUDIWERK_URL = "https://www.studiwerk.de";
    static let API = "https://www.studiwerk.de/export/speiseplan.xml"
    static let NOODLE_COUNTER = "CASA BLANCA"
    static let MAIN_DISH_MINIMAL_PRICE: Double = 1.15
    static let groupIdentifier = "group.de.marc-hein.Mensaplan.Data"
    static let appStoreId = "1491882125"
    static let mailAdress = "egygte@gmail.com"
    static let website = "https://github.com/FxeGfyvs/Canteenplan"
    static let versionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    static let askForReviewAt = 5
    static let sharedDefaults: UserDefaults = UserDefaults(suiteName: CanteenplanApp.groupIdentifier)!
}
class Opening {
    var semester: String
    var semesterFerien: String
    init(semester: String, semesterFerien: String) {
        self.semester = semester
        self.semesterFerien = semesterFerien
    }
}
