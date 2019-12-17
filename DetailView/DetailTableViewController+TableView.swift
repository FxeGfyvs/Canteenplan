import Foundation
import UIKit
extension DetailTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let day = mensaPlanDay {
            return day.counters.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let day = mensaPlanDay {
            return day.counters[section].meals.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealTableViewCell
        if let day = mensaPlanDay  {
            let meal = day.counters[indexPath.section].meals[indexPath.row]
            cell.mealTitleLabel.text = meal.title
            let selectedPrice = CanteenplanApp.sharedDefaults.string(forKey: LocalKeys.selectedPrice)
            if selectedPrice == "student" {
                cell.mealPriceLabel.text = meal.getFormattedPrice(price: meal.priceStudent)
            } else if selectedPrice == "worker" {
                cell.mealPriceLabel.text = meal.getFormattedPrice(price: meal.priceWorker)
            } else if selectedPrice == "guest" {
                cell.mealPriceLabel.text = meal.getFormattedPrice(price: meal.pricePublic)
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         guard let header = view as? UITableViewHeaderFooterView else { return }
           header.textLabel?.textColor = UIColor.white
    }
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
         guard let header = view as? UITableViewHeaderFooterView else { return }
           header.textLabel?.textColor = UIColor.white
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let day = mensaPlanDay {
            return day.counters[section].label
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
