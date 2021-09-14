//
//  Extensions.swift
//  AirQualityMonitor
//
//  Created by Rajasekhar on 13/09/21.
//

import Foundation
import UIKit

// MARK: Double value Extensions
extension Double {
    var roundTo2f: Double {
        return Double((100 * self).rounded()/100)
    }
    var toRadians: CGFloat {
        return CGFloat(self) * CGFloat(Double.pi) / 180.0
    }
}

// MARK: Custom Colors
extension UIColor {
    static let greenWithAlpha = UIColor(red: 0, green: 106.color, blue: 0, alpha: 0.5)
    static let yellowWithAlpha = UIColor(red: 255.color, green: 255.color, blue: 191.color, alpha: 1.0)
    static let orangeWithAlpha = UIColor.orange.withAlphaComponent(0.5)
    static let redWithAlpha = UIColor.red.withAlphaComponent(0.5)
    static let brownWithAlpha = UIColor.brown.withAlphaComponent(0.5)
    static let darkgreenWithAlpha = UIColor(red: 0, green: 200.color, blue: 0, alpha: 1)
    static let darkgreen = UIColor(red: 0, green: 106.color, blue: 0, alpha: 1)
    static let darkred = UIColor(red: 191.color, green: 0, blue: 0, alpha: 1)
    static let darkyellow = UIColor(red: 222.color, green: 194.color, blue: 11.color, alpha: 1)
}

// MARK: Double value Extensions
extension Int {
    var color: CGFloat {
        return CGFloat(Double(self)/255.0)
    }
    
}

// MARK: ViewController Extensions
extension UIViewController {
    var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
   }
    
    func showAlert(title:String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in }
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

func getIndexForAQI(aqi: Double, needAccurateValue: Bool = true) -> Double {
    var indexValue: Double = 0
    var decimalValue: Double = 0
    
    switch aqi {
    case 0.0...50.00:
        indexValue = 1
        decimalValue = aqi/50.0
    case 50.01...100.00:
        indexValue = 2
        decimalValue = (aqi-50.0)/50.0
    case 100.01...200.00:
        indexValue = 3
        decimalValue = (aqi-100.0)/100.0
    case 200.01...300.00:
        indexValue = 4
        decimalValue = (aqi-200.0)/100.0
    case 300.01...400.00:
        indexValue = 5
        decimalValue = (aqi-300.0)/100.0
    case 400.01...500.00:
        indexValue = 6
        decimalValue = (aqi-400.0)/100.0
    default:
        indexValue = 7
    }
    return needAccurateValue ? indexValue + decimalValue : indexValue
}
