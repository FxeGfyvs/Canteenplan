import Foundation
struct Mensaplan: Decodable {
    let plan: [Location]
    enum CodingKeys : String, CodingKey {
        case plan = "plan"
    }
}
struct Location: Decodable {
    let day: [LocationDay]
    enum CodingKeys : String, CodingKey {
        case day = "location"
    }
}
struct LocationDay: Decodable {
    let data: MensaplanDay
    let date: Int
    let title: String
    enum CodingKeys : String, CodingKey {
        case date
        case data
        case title
    }
    func isToday() -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMdd"
        let date = dateFormatterGet.date(from: "\(self.date)")!
        return Calendar.current.isDateInToday(date)
    }
    func isTomorrow() -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMdd"
        let date = dateFormatterGet.date(from: "\(self.date)")!
        return Calendar.current.isDateInTomorrow(date)
    }
    func getDateValue() -> Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMdd"
        return dateFormatterGet.date(from: "\(self.date)")!
    }
    func getDate(showDay: Bool = true) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMdd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        if let date = dateFormatterGet.date(from: "\(self.date)") {
            var resultString = dateFormatterPrint.string(from: date)
            if showDay {
                if Calendar.current.isDateInYesterday(date) {
                    resultString = "\(resultString) - (Gestern)"
                } else if Calendar.current.isDateInToday(date) {
                    resultString = "\(resultString) - (Heute)"
                } else if Calendar.current.isDateInTomorrow(date) {
                    resultString = "\(resultString) - (Morgen)"
                }
            }
            return  resultString
        } else {
           print("There was an error decoding the string")
        }
        return nil
    }
}
struct MensaplanDay: Decodable {
    let date: Int
    let counters: [Counter]
    enum CodingKeys : String, CodingKey {
        case date
        case counters
    }
    func getDateValue() -> Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMdd"
        return dateFormatterGet.date(from: "\(self.date)")!
    }
    func getDate(showDay: Bool = true) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMdd"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        if let date = dateFormatterGet.date(from: "\(self.date)") {
            var resultString = dateFormatterPrint.string(from: date)
            if showDay {
                if Calendar.current.isDateInYesterday(date) {
                    resultString = "\(resultString) - (Gestern)"
                } else if Calendar.current.isDateInToday(date) {
                    resultString = "\(resultString) - (Heute)"
                } else if Calendar.current.isDateInTomorrow(date) {
                    resultString = "\(resultString) - (Morgen)"
                }
            }
            return  resultString
        } else {
           print("There was an error decoding the string")
        }
        return nil
    }
    func isToday() -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMdd"
        let date = dateFormatterGet.date(from: "\(self.date)")!
        return Calendar.current.isDateInToday(date)
    }
    func isTomorrow() -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMdd"
        let date = dateFormatterGet.date(from: "\(self.date)")!
        return Calendar.current.isDateInTomorrow(date)
    }
}
struct Counter: Decodable {
    let label: String
    let meals: [Meal]
    enum CodingKeys : String, CodingKey {
       case label
       case meals
   }
}
struct Meal: Decodable {
    let title: String
    let priceStudent: Double
     let priceWorker: Double
     let pricePublic: Double
    let image: String?
    enum CodingKeys : String, CodingKey {
        case title
        case priceStudent
        case priceWorker
        case pricePublic
        case image
    }
    func getFormattedPrice(price: Double) -> String? {
        return String(format: "%.02f€", price)
    }
}
