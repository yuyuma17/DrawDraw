//
//  CanvasView.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2019/9/11.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    var lines = [[CGPoint]]()
    var brushWidth: CGFloat = 4
    var brushColor: UIColor = .black
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(brushColor.cgColor)
        
        lines.forEach { (line) in
            for (i, p) in line.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first?.location(in: self) else {
            return
        }
        
        guard var lastPoint = lines.popLast() else { return }
        lastPoint.append(touch)
        lines.append(lastPoint)
        
        setNeedsDisplay()
    }
    
    func clearCanvas() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    func undo() {
        guard lines.count > 0 else {
            return
        }
        lines.removeLast()
        setNeedsDisplay()
    }
    
    func redo() {
        
    }
}
