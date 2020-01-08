//
//  ViewController.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2019/9/11.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var canvas: CanvasView!
    @IBOutlet weak var selectBrushColorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvas.isMultipleTouchEnabled = false
        view.setViewWithBorderAndCircle(selectBrushColorButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if buttomView.frame.height == 896 || buttomView.frame.height == 812 {
            buttomView.layer.cornerRadius = 40
        } else {
            buttomView.layer.cornerRadius = 20
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        test2()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        canvas.clearCanvas()
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

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath) as! TestCollectionViewCell
        cell.testButton.titleLabel?.text = "123"
        return cell
    }
}
