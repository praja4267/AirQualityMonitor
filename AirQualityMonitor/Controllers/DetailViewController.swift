//
//  DetailViewController.swift
//  AirQualityMonitor
//
//  Created by Rajasekhar on 13/09/21.
//

import UIKit

class DetailViewController: UIViewController {
    var radius : CGFloat {
        return self.view.frame.size.width - 20
    }
    var model: AQIModel? {
        didSet {
            updateProgressView()
        }
    }
    var circle: Circle?
    
    enum AirQuality: String {
        case good = "Good"
        case satisfactory = "Satisfactory"
        case moderate = "Moderate"
        case poor = "Poor"
        case veryPoor = "Very Poor"
        case severe = "Severe"
    }

    @IBOutlet weak var progressView: MKMagneticProgress!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var aqiGuideView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model?.city ?? ""
        addbackgroundSemiCircle()
        progressView.backgroundColor = .clear
        progressView.spaceDegree = CGFloat(90.0)
        progressView.lineWidth = 15
        updateProgressView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubviewToFront(progressView)
        self.view.bringSubviewToFront(infoLabel)
        self.view.bringSubviewToFront(aqiGuideView)
    }
    
    func addbackgroundSemiCircle() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarHeight = self.navigationController?.navigationBar.bounds.size.height ?? 0;
        let rect = CGRect(x: 10, y: statusBarHeight+navBarHeight + 10, width: view.frame.width - 20, height: view.frame.width - 20)
        let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        if circle != nil {
            circle?.removeFromSuperview()
            circle = nil
        }
        circle = Circle(frame: rect, center: center, radius: (view.frame.width - 20)/2, lineWidth: 15)
        guard let circle = circle else { return }
        circle.backgroundColor = .clear;
        view.addSubview(circle)
    }
    
    func getColorForCurrentAQI(index: Double) -> (UIColor, String) {
        var color: UIColor
        var airQuality: AirQuality
        
        switch index {
        case 0.00..<2.00: color = UIColor.darkgreen
            airQuality = .good
        case 2.00..<3.00: color = UIColor.darkgreenWithAlpha
            airQuality = .satisfactory
        case 3.00..<4.00: color = UIColor.darkyellow
            airQuality = .moderate
        case 4.00..<5.00: color = UIColor.orange
            airQuality = .poor
        case 5.00..<6.00: color = UIColor.red
            airQuality = .veryPoor
        default:
            color = UIColor.darkred
            airQuality = .severe
        }
        return (color, airQuality.rawValue)
    }
    
    func updateProgressView() {
        let index = getIndexForAQI(aqi: model?.aqi ?? 0, needAccurateValue: true)
        let (color, desc) = getColorForCurrentAQI(index: index)
        progressView?.progressShapeColor = color
        let progressVal = (index-1)/6.0
        progressView?.setProgress(progress: CGFloat(progressVal), animated: true)
        infoLabel?.text = "\(model?.aqi ?? 0) \n\(desc)"
        infoLabel?.textColor = color
    }
}

