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
    var undoLines = [[CGPoint]]()
    var brushWidth: CGFloat = 4
    var brushColor: UIColor = .black
    
    weak var paintingVC: PaintingViewController?
    
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
        
        if lines.count == 0 {
            paintingVC?.clearCanvasButton.isEnabled = true
            paintingVC?.undoButton.isEnabled = true
        }
        
        if undoLines.count != 0 {
            paintingVC?.redoButton.isEnabled = false
            undoLines.removeAll()
        }
        
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
        
        if lines.count > 1 {
            paintingVC?.undoButton.isEnabled = true
            paintingVC?.redoButton.isEnabled = true
            undoLines.append(lines.removeLast())
            setNeedsDisplay()
        } else if lines.count == 1 {
            paintingVC?.undoButton.isEnabled = false
            paintingVC?.redoButton.isEnabled = true
            paintingVC?.clearCanvasButton.isEnabled = false
            undoLines.append(lines.removeLast())
            setNeedsDisplay()
        }
    }
    
    func redo() {
        
        if undoLines.count > 1 {
            paintingVC?.undoButton.isEnabled = true
            paintingVC?.clearCanvasButton.isEnabled = true
            lines.append(undoLines.last!)
            undoLines.removeLast()
            setNeedsDisplay()
        } else if undoLines.count == 1 {
            paintingVC?.undoButton.isEnabled = true
            paintingVC?.redoButton.isEnabled = false
            paintingVC?.clearCanvasButton.isEnabled = true
            lines.append(undoLines.last!)
            undoLines.removeLast()
            setNeedsDisplay()
        }
    }
}
