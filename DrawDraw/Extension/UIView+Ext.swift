//
//  UIView+Ext.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2020/1/8.
//  Copyright © 2020 黃士軒. All rights reserved.
//

import UIKit

extension UIView {
    
    func setViewWithRoundCornerRadius(_ view: UIView) {
        view.layer.cornerRadius = view.frame.height / 2
    }
    
    func setViewWithFadeAwayAnimation(_ view: UIView) {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            view.alpha = 0
        }) { (_) in
            view.isHidden = true
        }
    }
    
    func setViewWithShowUpAnimation(_ view: UIView) {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            view.alpha = 1
            view.isHidden = false
        }, completion: nil)
    }
}
