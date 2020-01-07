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
    
    @IBAction func changeColor(_ sender: UIButton) {
        canvas.paintingColor = .red
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
//        takeScreenshot()
//        test()
        test2()
    
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
    
    func test2() {
        
        UIGraphicsBeginImageContextWithOptions(canvas.frame.size, true, 0)
        canvas.drawHierarchy(in: canvas.bounds, afterScreenUpdates: true)
        let shareImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let activityViewController = UIActivityViewController(activityItems: [shareImage!], applicationActivities: [])
        activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList, .openInIBooks, .markupAsPDF, .postToVimeo, .postToWeibo, .postToFlickr, .postToTwitter]
        
        self.present(activityViewController, animated: true, completion: nil)
        
        // MARK: Activity Controller Completion Handler with Alert
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if !completed {
                // handle task not completed
                print(error ?? "user canceled sharing")
                return
            }
            let activityText: [String] = (activity?.rawValue.components(separatedBy: "."))!
            let controller = UIAlertController(title: "Successed!", message: "Successfully shared by \"\(activityText[activityText.count - 1])\"", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true, completion: nil)
        }
        
        
    }
    
}

