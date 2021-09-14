//
//  AQITableViewCell.swift
//  MyCharts
//
//  Created by Rajasekhar on 13/09/21.
//

import UIKit

class AQITableViewCell: UITableViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var aqiValueLabel: UILabel!
    @IBOutlet weak var indexView: UIView!
    @IBOutlet weak var indexViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var aqiProgressView: UIProgressView!
    
    var maxWidth: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        maxWidth = self.frame.width - 200
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUi(with model: AQIModel?) {
        guard let model = model else { return }
        cityNameLabel.text = model.city
        let timeGap = Int(Date().timeIntervalSince(model.time!))
        updatedTimeLabel.text = timeGap > 1 ? "Updated few seconds ago" : "Updated just now"
        aqiValueLabel.text = "\(model.aqi)"
        let index = getIndexForAQI(aqi: model.aqi)
        let (color, width) = getColorForCurrentAQI(index: index)
        aqiProgressView.tintColor = color
        self.indexViewWidthConstraint.constant = width
        aqiProgressView.setProgress(1.0, animated: true)
    }
    
    func getColorForCurrentAQI(index: Double) -> (UIColor, CGFloat) {
        var color: UIColor
        let width: CGFloat = (CGFloat(index/7.0)) * maxWidth
        
        switch (index) {
        case 1.00..<2.00: color = UIColor.darkgreen
        case 2.00..<3.00: color = UIColor.darkgreenWithAlpha
        case 3.00..<4.00: color = UIColor.yellow
        case 4.00..<5.00: color = UIColor.orange
        case 5.00..<6.00: color = UIColor.red
        default:
            color = UIColor.darkred
        }
        return (color, width < maxWidth - 10 ? width : maxWidth)
    }
}


