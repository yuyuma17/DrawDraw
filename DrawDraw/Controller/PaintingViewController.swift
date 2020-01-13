//
//  PaintingViewController.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2019/9/11.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit

class PaintingViewController: UIViewController {

    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectColorView: UIView!
    @IBOutlet weak var canvas: CanvasView!
    @IBOutlet weak var selectBrushColorButton: UIButton!
    @IBOutlet weak var backToPreviousStepButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setViewWithBorderAndCircle(selectBrushColorButton)
        backToPreviousStepButton.isEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if buttomView.frame.height == 896 || buttomView.frame.height == 812 {
            buttomView.layer.cornerRadius = 0
        } else {
            buttomView.layer.cornerRadius = 15
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        sharePainting()
    }
    
    @IBAction func clearCanvasButtonPressed(_ sender: UIButton) {
        
        showAlert(alertTitle: "Do you want to clear the canvas?", alertMessage: nil, [alertAction("No", .default, nil), alertAction("Yes", .destructive, { [weak self] (UIAlertAction) in
            
            guard let self = self else { return }
            self.canvas.clearCanvas()
        })])
    }
    
    @IBAction func selectBrushColorButtonPressed(_ sender: UIButton) {
        view.setViewWithDelayAnimation(selectColorView)
    }
    
}

extension PaintingViewController {
    
    private func sharePainting() {
        
        UIGraphicsBeginImageContextWithOptions(canvas.frame.size, true, 0)
        canvas.drawHierarchy(in: canvas.bounds, afterScreenUpdates: true)
        let shareImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activityVC = UIActivityViewController(activityItems: [shareImage!], applicationActivities: [])
        
        activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList, .openInIBooks, .markupAsPDF, .postToVimeo, .postToWeibo, .postToFlickr, .postToTwitter]
        
        present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = { [weak self] activity, completed, items, error in
            
            guard let self = self else { return }
            
            if !completed {
                print(error ?? "User canceled sharing.")
                return
            }
            
            self.showAlert(alertTitle: "Succeed!", alertMessage: "Successfully shard!", [self.alertAction("OK", .default, nil)])
        }
    }
    
    private func showAlert(alertTitle: String, alertMessage: String?, _ actions: [UIAlertAction]) {
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        for i in 0..<actions.count {
            alert.addAction(actions[i])
        }
        present(alert, animated: true, completion: nil)
    }
    
    private func alertAction(_ actionTitle: String, _ actionStyle: UIAlertAction.Style, _ handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        
        let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: handler)
        
        return action
    }
}

//To do
extension PaintingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath) as! TestCollectionViewCell
        cell.testButton.titleLabel?.text = "123"
        return cell
    }
}
