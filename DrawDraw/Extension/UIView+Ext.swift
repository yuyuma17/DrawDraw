//
//  UIView+Ext.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2020/1/8.
//  Copyright © 2020 黃士軒. All rights reserved.
//

import UIKit

extension UIView {
    
    func setViewWithBorderAndCircle(_ view: UIView) {
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1.5
    }
}