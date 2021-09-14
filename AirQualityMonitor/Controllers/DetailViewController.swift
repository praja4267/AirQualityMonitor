//
//  DetailViewController.swift
//  AirQualityMonitor
//
//  Created by Rajasekhar on 13/09/21.
//

import UIKit


enum AirQuality: String {
    case good = "Good"
    case satisfactory = "Satisfactory"
    case moderate = "Moderate"
    case poor = "Poor"
    case veryPoor = "Very Poor"
    case severe = "Severe"
}

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
    var progress: Double {
        return model?.aqi ?? 0
    }
    
    @IBOutlet weak var progressView: MKMagneticProgress!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var aqiGuideView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model?.city ?? ""
        addCircleparts()
        progressView.backgroundColor = .clear
        progressView.spaceDegree = CGFloat(90.0)
        progressView.lineWidth = 15
        updateProgressView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubviewToFront(progressView)
        self.view.bringSubviewToFront(infoLabel)
        self.view.bringSubviewToFront(aqiGuideView)
    }
    func addCircleparts() {
        let part1 = CirclePart(startAngle: 0, endAngle: 30, color: .greenWithAlpha)
        let part2 = CirclePart(startAngle: 30, endAngle: 60, color: UIColor.green.withAlphaComponent(0.3))
        let part3 = CirclePart(startAngle: 60, endAngle: 90, color: .yellowWithAlpha)
        let part4 = CirclePart(startAngle: 90, endAngle: 120, color: .orangeWithAlpha)
        let part5 = CirclePart(startAngle: 120, endAngle: 150, color: .redWithAlpha)
        let part6 = CirclePart(startAngle: 150, endAngle: 180, color: .brownWithAlpha)
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarHeight = self.navigationController?.navigationBar.bounds.size.height ?? 0;
        let rect = CGRect(x: 10, y: statusBarHeight+navBarHeight + 10, width: view.frame.width - 20, height: view.frame.width - 20)
        let center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        if circle != nil {
            circle?.removeFromSuperview()
            circle = nil
        }
        circle = Circle(frame: rect, center: center, radius: (view.frame.width - 20)/2, lineWidth: 10, circleParts: [part1, part2, part3, part4, part4, part5, part6])
        guard let circle = circle else { return }
        circle.backgroundColor = .clear;
        view.addSubview(circle)
    }
    
    func radians(degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / 180)
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
    func getProgressValue(currrentIndex: Double) -> Double {
        return (currrentIndex - 1.00)/6.0
    }
    func updateProgressView() {
        let index = getIndexForAQI(aqi: model?.aqi ?? 0, needAccurateValue: true)
        let (color, desc) = getColorForCurrentAQI(index: index)
        progressView?.progressShapeColor = color
        let progressVal = getProgressValue(currrentIndex: index)
        progressView?.setProgress(progress: CGFloat(progressVal), animated: true)
        infoLabel?.text = "\(model?.aqi ?? 0) \n\(desc)"
        infoLabel?.textColor = color
    }
}

