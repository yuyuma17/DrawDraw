//
//  CanvasView.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2019/9/11.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    fileprivate var lines = [Line]()
    fileprivate var undoLines = [Line]()
    fileprivate var brushColor: UIColor = .black
    fileprivate var brushWidth: Float = 4
    fileprivate var brushAlpha: Float = 1
    
    weak var paintingVC: PaintingViewController?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        lines.forEach { (line) in
            
            context.setStrokeColor(UIColor.white.cgColor)
//            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.width))
            context.setAlpha(CGFloat(line.alpha))
            
            
            let shadowColor = UIColor.red
            let transparentShadowColor = shadowColor.withAlphaComponent(1)
            context.setShadow(offset: CGSize(width: 0, height: 0), blur: CGFloat(line.width / 1.25), color: transparentShadowColor.cgColor)
//            context.setBlendMode(.screen)
            
            for (i, p) in line.points.enumerated() {
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
        
        if lines.count == 0 {
            paintingVC?.clearCanvasButton.isEnabled = true
            paintingVC?.undoButton.isEnabled = true
        }
        
        if undoLines.count != 0 {
            paintingVC?.redoButton.isEnabled = false
            undoLines.removeAll()
        }
        
        lines.append(Line.init(color: brushColor, width: brushWidth, alpha: brushAlpha, points: []))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: self) else {
            return
        }
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
    
    func clearCanvas() {
        guard lines.count > 0 else {
            return
        }
        lines.removeAll()
        undoLines.removeAll()
        paintingVC?.undoButton.isEnabled = false
        paintingVC?.redoButton.isEnabled = false
        paintingVC?.clearCanvasButton.isEnabled = false
        setNeedsDisplay()
    }
    
    func undo() {
        
        if lines.count == 1 {
            paintingVC?.undoButton.isEnabled = false
            paintingVC?.clearCanvasButton.isEnabled = false
        }
        if paintingVC?.redoButton.isEnabled == false {
            paintingVC?.redoButton.isEnabled = true
        }
        undoLines.append(lines.removeLast())
        setNeedsDisplay()
    }
    
    func redo() {
        
        if undoLines.count == 1 {
            paintingVC?.redoButton.isEnabled = false
        }
        if paintingVC?.undoButton.isEnabled == false {
            paintingVC?.undoButton.isEnabled = true
        }
        if paintingVC?.clearCanvasButton.isEnabled == false {
            paintingVC?.clearCanvasButton.isEnabled = true
        }
        lines.append(undoLines.last!)
        undoLines.removeLast()
        setNeedsDisplay()
    }
    
    func setBrushColor(color: UIColor) {
        brushColor = color
    }
    
    func setBrushWidth(width: Float) {
        brushWidth = width
    }
    
    func setBrushAlpha(alpha: Float) {
        brushAlpha = alpha
    }
}
