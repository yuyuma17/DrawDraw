//
//  PaintingViewController.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2019/9/11.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit

class PaintingViewController: UIViewController {

    var colorsArray: [UIColor] = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.4059419876, blue: 0.2455089305, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 1, green: 0.4059419876, blue: 0.2455089305, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3823936913, green: 0.8900789089, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.4528176247, blue: 0.4432695911, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]
    
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectColorView: UIView!
    @IBOutlet weak var canvas: CanvasView!
    @IBOutlet weak var selectBrushColorButton: UIButton!
    @IBOutlet weak var clearCanvasButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvas.paintingVC = self
        undoButton.isEnabled = false
        redoButton.isEnabled = false
        clearCanvasButton.isEnabled = false
        view.setViewWithBorderAndCircle(selectBrushColorButton)
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
        
        showAlert(alertTitle: "Do you want to clear the canvas?", alertMessage: nil, [alertAction("No", .default, nil), alertAction("Yes", .destructive, { [weak self] (_) in
            
            guard let self = self else { return }
            self.canvas.clearCanvas()
        })])
    }
    
    @IBAction func undoButtonPressed(_ sender: UIButton) {
        canvas.undo()
    }
    
    @IBAction func redoButtonPressed(_ sender: UIButton) {
        canvas.redo()
    }
    
    @IBAction func selectBrushColorButtonPressed(_ sender: UIButton) {

        if selectColorView.isHidden == true {
            view.setViewWithShowUpAnimation(selectColorView)
        } else {
            view.setViewWithFadeAwayAnimation(selectColorView)
        }
    }
}

extension PaintingViewController {
    
    private func sharePainting() {
        
        UIGraphicsBeginImageContextWithOptions(canvas.frame.size, true, 0)
        canvas.drawHierarchy(in: canvas.bounds, afterScreenUpdates: true)
        let shareImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        showActivityVC([shareImage!]) { [weak self] (activityType, completed, items, error) in
            
            guard let self = self else { return }
            
            if !completed {
                print(error ?? "User canceled sharing.")
                return
            }
            self.showAlert(alertTitle: "Succeed!", alertMessage: "Successfully completed!", [self.alertAction("OK", .default, nil)])
        }
    }
    
    private func showActivityVC(_ activityItems: [Any], _ handler: UIActivityViewController.CompletionWithItemsHandler?) {
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [.assignToContact, .message, .mail, .addToReadingList, .openInIBooks, .markupAsPDF, .postToVimeo, .postToWeibo, .postToFlickr]
        
        present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = handler
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
extension PaintingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath) as! TestCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
