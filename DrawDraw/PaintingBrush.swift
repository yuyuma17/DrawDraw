//
//  PaintingBrush.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2020/1/2.
//  Copyright © 2020 黃士軒. All rights reserved.
//

import UIKit

enum PaintingBrushColor {
    
    case red
    case black
    
    var color: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .black:
            return UIColor.black
        }
    }
}
