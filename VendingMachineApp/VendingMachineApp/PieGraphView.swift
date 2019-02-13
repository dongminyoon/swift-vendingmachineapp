//
//  PieGraphView.swift
//  VendingMachineApp
//
//  Created by 윤동민 on 31/01/2019.
//  Copyright © 2019 윤동민. All rights reserved.
//

import UIKit

class PieGraphView: UIView {
    var data: DataSet?
    
    func set(data: DataSet?) {
        self.data = data
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let radius = min(frame.size.width, frame.size.height) * 0.5
        let viewCenter = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
        

        guard let data = self.data else { return }
        var valueCount: Int {
            var count = 0
            for (_, value) in data.countOfEachPurchasedDrink { count += value }
            return count
        }
        
        drawPieGraph(ctx: ctx, radius: radius, viewCenter: viewCenter, valueCount: valueCount)
    }
    
    private func drawPieGraph(ctx: CGContext?, radius: CGFloat, viewCenter: CGPoint, valueCount: Int) {
        var startAngle = -CGFloat.pi * 0.5
        var colorRedValue: CGFloat = 0
        var colorBlueValue: CGFloat = 1
        
        guard let data = self.data else { return }
        for(key, value) in data.countOfEachPurchasedDrink {
            ctx?.setFillColor(UIColor(red: colorRedValue, green: 0, blue: colorBlueValue, alpha: 1.0).cgColor)
            
            let endAngle = startAngle + 2 * .pi * (CGFloat(value) / CGFloat(valueCount))
            
            ctx?.move(to: viewCenter)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            ctx?.fillPath()
            
            if value != 0 { drawLabel(text: key as NSString, startAngle: startAngle, endAngle: endAngle) }
            
            startAngle = endAngle
            
            colorRedValue += 0.2
            colorBlueValue -= 0.2
        }
    }
    
    private func drawLabel(text: NSString, startAngle: CGFloat, endAngle: CGFloat) {
        let fontSize = CGFloat(15)
        let moveLeft = CGFloat(text.length) * fontSize * 0.27
        let angle = startAngle + (endAngle - startAngle) * 0.5
        let point = CGPoint(x: frame.size.width / 2 + (min(frame.size.width, frame.size.height) * 0.5 * cos(angle)) * 0.5 - moveLeft,
                            y: frame.size.height / 2 + (min(frame.size.width, frame.size.height) * 0.5 * sin(angle)) * 0.5 - fontSize)
        text.draw(at: point, withAttributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize),
                                              NSAttributedString.Key.foregroundColor: UIColor.white])
    }

}