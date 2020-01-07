//
//  CanvasViewController.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2019/9/11.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit

class CanvasViewController: UIView {

    var paintingColor = PaintingBrushColor.black
    
//    lazy var paintingBrushColor = paintingColor.color
    var paintingBrushWidth: CGFloat = 8
    var paintingPath: UIBezierPath!
    var beginPoint: CGPoint!
    var endPoint: CGPoint!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        beginPoint = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        endPoint = touches.first?.location(in: self)
        paintingPath = UIBezierPath()
        paintingPath.move(to: beginPoint)
        paintingPath.addLine(to: endPoint)
        beginPoint = endPoint
        draw()
    }
    
    func draw() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = paintingPath.cgPath
        shapeLayer.strokeColor = paintingColor.color.cgColor
        shapeLayer.lineWidth = paintingBrushWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        layer.addSublayer(shapeLayer)
        setNeedsDisplay()
    }
    
    func clearCanvas() {
        paintingPath.removeAllPoints()
        layer.sublayers = nil
        setNeedsDisplay()
    }
}
