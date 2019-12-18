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
    
    @IBAction func saveButton(_ sender: UIButton) {
//        takeScreenshot()
        test()
    
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        canvas.clearCanvas()
    }
    
    func takeScreenshot(_ shouldSave: Bool = true) {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return }
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    func test() {
        
          let renderer = UIGraphicsImageRenderer(size: canvas.bounds.size)
           let image = renderer.image(actions: { (context) in
              canvas.drawHierarchy(in: canvas.bounds, afterScreenUpdates: true)
        })
           let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
           present(activityViewController, animated: true, completion: nil)
        
        
    }
    
}

