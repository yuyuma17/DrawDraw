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
    fileprivate var shadowColor: UIColor = .black
    fileprivate var brushWidth: Float = 4
    fileprivate var brushAlpha: Float = 1
    fileprivate var brushBlur: Float = 0
    fileprivate var paintingBrushType = BrushType.normal
    
    weak var paintingVC: PaintingViewController?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        lines.forEach { (line) in
            
            context.setStrokeColor(line.color.cgColor)
            context.setShadow(offset: CGSize(width: 0, height: 0), blur: CGFloat(line.blur), color: line.shadow.cgColor)
            context.setLineWidth(CGFloat(line.width))
            context.setAlpha(CGFloat(line.alpha))
            
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
        
        if paintingVC?.selectColorView.isHidden == false {
            paintingVC?.view.setViewWithFadeAwayAnimation(paintingVC!.selectColorView)
        }
        
        if paintingVC?.selectWidthAndAlphaView.isHidden == false {
            paintingVC?.view.setViewWithFadeAwayAnimation(paintingVC!.selectWidthAndAlphaView)
        }
        
        lines.append(Line.init(color: brushColor, shadow: shadowColor, width: brushWidth, alpha: brushAlpha, blur: brushBlur, points: []))
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
    
    func setBrushWidth(width: Float) {
        brushWidth = width
    }
    
    func setBrushAlpha(alpha: Float) {
        brushAlpha = alpha
    }
    
    func setBrushTypeToNormal() {
        paintingBrushType = .normal
        brushBlur = 0
        brushColor = shadowColor
    }
    
    func setBrushTypeToBlur() {
        paintingBrushType = .blur
        brushBlur = brushWidth * 1.5
        brushColor = shadowColor
    }
    
    func setBrushTypeToNeon(neonInnerColor: UIColor = .white) {
        paintingBrushType = .neon
        brushBlur = brushWidth * 1.5
        brushColor = neonInnerColor
    }
    
    func setBrushColor(color: UIColor) {
        
        switch paintingBrushType {
            
        case .normal:
            brushColor = color
            shadowColor = color
        case .blur:
            brushColor = color
            shadowColor = color
        case .neon:
            shadowColor = color
        }
    }
}
