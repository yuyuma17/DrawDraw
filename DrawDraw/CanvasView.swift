//
//  CanvasView.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2019/9/11.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    var paintingColor = PaintingBrushColor.black
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
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        layer.addSublayer(shapeLayer)
//        setNeedsDisplay()
    }
    
    func clearCanvas() {
        
        if paintingPath != nil {
            paintingPath.removeAllPoints()
        } else {
            return
        }
        layer.sublayers = nil
//        setNeedsDisplay()
    }
    
    func undo() {
        
        
    }
}
