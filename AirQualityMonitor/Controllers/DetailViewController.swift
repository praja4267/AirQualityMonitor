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
    var progress: Double {
        return model?.aqi ?? 0
    }
    
    @IBOutlet weak var progressView: MKMagneticProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = model?.city ?? ""
        addCircleparts()
        progressView.backgroundColor = .clear
        progressView.spaceDegree = CGFloat(90.0)
        progressView.lineWidth = 10
        updateProgressView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubviewToFront(progressView)
    }
    func addCircleparts() {
        let part1 = CirclePart(startAngle: 0, endAngle: 30, color: .greenWithAlpha)
        let part2 = CirclePart(startAngle: 30, endAngle: 60, color: UIColor.green.withAlphaComponent(0.3))
        let part3 = CirclePart(startAngle: 60, endAngle: 90, color: .yellowWithAlpha)
        let part4 = CirclePart(startAngle: 90, endAngle: 120, color: .orangeWithAlpha)
        let part5 = CirclePart(startAngle: 120, endAngle: 150, color: .redWithAlpha)
        let part6 = CirclePart(startAngle: 150, endAngle: 180, color: .brownWithAlpha)
        
        let rect = CGRect(x: 10, y: 100, width: view.frame.width - 20, height: view.frame.width - 20)
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
        var description = ""
        
        switch index {
        case 0.00..<2.00: color = UIColor.darkgreen
            description = "Good"
        case 2.00..<3.00: color = UIColor.darkgreenWithAlpha
            description = "Satisfactory"
        case 3.00..<4.00: color = UIColor.darkyellow
            description = "Moderate"
        case 4.00..<5.00: color = UIColor.orange
            description = "Poor"
        case 5.00..<6.00: color = UIColor.red
            description = "Very Poor"
        default:
            color = UIColor.darkred
            description = "Severe"
        }
        print("current index = \(Int(floor(index))), actual index = \(index), color  \(color)")
        return (color, description)
    }
    func getProgressValue(currrentIndex: Double) -> Double {
        print(" ***-***Current Index = \(currrentIndex), updatedprogress = \(currrentIndex/6.0)")
        return (currrentIndex - 1.00)/6.0
    }
    func updateProgressView() {
        let index = getIndexForAQI(aqi: model?.aqi ?? 0, needAccurateValue: true)
        let (color, desc) = getColorForCurrentAQI(index: index)
        progressView?.progressShapeColor = color
        let progressVal = getProgressValue(currrentIndex: index)
        progressView?.setProgress(progress: CGFloat(progressVal), animated: true)
        progressView?.title = "\(model?.aqi ?? 0) \n\(desc)"
    }
    
}

