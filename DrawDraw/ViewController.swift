//
//  ViewController.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2019/9/11.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvas: CanvasViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvas.isMultipleTouchEnabled = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func clearButton(_ sender: UIButton) {
        canvas.clearCanvas()
    }
    
}

