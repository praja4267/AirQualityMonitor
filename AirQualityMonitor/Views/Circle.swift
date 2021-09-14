//
//  Circle.swift
//  AirQualityMonitor
//
//  Created by Rajasekhar on 13/09/21.
//

import Foundation
import UIKit

struct CirclePart {
    let startAngle: Double
    let endAngle: Double
    let color: UIColor
}

class Circle: UIView {
    var centrePoint: CGPoint
    var radius: CGFloat
    var lineWidth: CGFloat
    var circleParts = [CirclePart]()
    var arrow = UIBezierPath().cgPath
    let arrowLayer = CAShapeLayer()
    init(frame: CGRect, center: CGPoint, radius: CGFloat, lineWidth: CGFloat, circleParts: [CirclePart] = Circle.getCircleParts()) {
        self.centrePoint = center
        self.radius = radius
        self.lineWidth = lineWidth
        self.circleParts = circleParts
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawCircle()
    }
    
    static func getCircleParts() -> [CirclePart] {
        let part1 = CirclePart(startAngle: -3, endAngle: 32, color: .greenWithAlpha)
        let part2 = CirclePart(startAngle: 32, endAngle: 62, color: UIColor.green.withAlphaComponent(0.3))
        let part3 = CirclePart(startAngle: 62, endAngle: 92, color: .yellowWithAlpha)
        let part4 = CirclePart(startAngle: 92, endAngle: 122, color: .orangeWithAlpha)
        let part5 = CirclePart(startAngle: 122, endAngle: 152, color: .redWithAlpha)
        let part6 = CirclePart(startAngle: 152, endAngle: 182, color: .darkred)
        return [part1, part2, part3, part4, part5, part6]
    }
   
    func drawCircle() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(lineWidth)
        for part in circleParts {
            context.move(to: centrePoint)
            let startAngle = part.startAngle.toRadians + CGFloat(Double.pi)
            let endAngle =  part.endAngle.toRadians + CGFloat(Double.pi)
            
            context.addArc(center: centrePoint, radius: radius, startAngle:startAngle , endAngle: endAngle, clockwise: false)
            context.setFillColor(part.color.cgColor)
            context.fillPath()
        }
        context.addArc(center: centrePoint, radius: radius - 20, startAngle: 0, endAngle: 180, clockwise: false)
        context.setFillColor(UIColor.white.cgColor)
        context.fillPath()
    }
}

