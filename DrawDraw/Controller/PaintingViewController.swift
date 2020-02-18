//
//  PaintingViewController.swift
//  DrawDraw
//
//  Created by 黃士軒 on 2019/9/11.
//  Copyright © 2019 黃士軒. All rights reserved.
//

import UIKit
import Photos

class PaintingViewController: UIViewController {

    fileprivate let colorsArray: [UIColor] = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0.4059419876, blue: 0.2455089305, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), #colorLiteral(red: 0.3823936913, green: 0.8900789089, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.4528176247, blue: 0.4432695911, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]
    
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectColorView: UIView!
    @IBOutlet weak var selectWidthAndAlphaView: UIView!
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
        selectColorView.isHidden = true
        selectColorView.alpha = 0
        selectWidthAndAlphaView.isHidden = true
        selectWidthAndAlphaView.alpha = 0
        view.setViewWithRoundCornerRadius(selectBrushColorButton)
        
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({_ in})
        }
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
        
        showAlert(alertTitle: "Clear the canvas?", alertMessage: nil, alertStyle: .alert, [alertAction("No", .default, nil), alertAction("Yes", .destructive, { [weak self] (_) in
            
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
    
    @IBAction func selectBrushTypeButtonPressed(_ sender: UIButton) {
        showAlert(alertTitle: "Select One Type Of Brushes" , alertMessage: nil, alertStyle: .alert, [alertAction("Normal", .default, { [weak self] (_) in
            guard let self = self else { return }
            self.canvas.setBrushTypeToNormal()
        }), alertAction("Blur", .default, { [weak self] (_) in
            guard let self = self else { return }
            self.canvas.setBrushTypeToBlur()
        }), alertAction("Neon", .default, { [weak self] (_) in
            guard let self = self else { return }
            self.canvas.setBrushTypeToNeon()
        }), alertAction("Cancel", .cancel, nil)])
    }
    
    @IBAction func selectBrushColorButtonPressed(_ sender: UIButton) {

        if selectColorView.isHidden == true {
            view.setViewWithShowUpAnimation(selectColorView)
        } else {
            view.setViewWithFadeAwayAnimation(selectColorView)
        }
        
        if selectWidthAndAlphaView.isHidden == false {
            view.setViewWithFadeAwayAnimation(selectWidthAndAlphaView)
        }
    }
    
    @IBAction func selectBrushWidthAndAlphaButtonPressed(_ sender: UIButton) {
        
        if selectWidthAndAlphaView.isHidden == true {
            view.setViewWithShowUpAnimation(selectWidthAndAlphaView)
        } else {
            view.setViewWithFadeAwayAnimation(selectWidthAndAlphaView)
        }
        
        if selectColorView.isHidden == false {
            view.setViewWithFadeAwayAnimation(selectColorView)
        }
    }
    
    @IBAction func brushWidthSlided(_ sender: UISlider) {
        canvas.setBrushWidth(width: sender.value)
    }
    
    @IBAction func brushAlphaSlided(_ sender: UISlider) {
        canvas.setBrushAlpha(alpha: sender.value)
    }
    
    @IBAction func saveScreenshotButtonPressed(_ sender: UIButton) {
        
        switch PHPhotoLibrary.authorizationStatus() {
        
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] (status) in
                guard let self = self else { return }
                guard status == .authorized else { return }
                self.showSaveScreenShotAlert()
            }
        case .restricted:
            showOpenAuthSettingAlert()
        case .denied:
            showOpenAuthSettingAlert()
        case .authorized:
            showSaveScreenShotAlert()
        @unknown default:
            fatalError()
        }
    }
}

extension PaintingViewController {
    
    private func canvasScreenshot() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(canvas.frame.size, true, 0)
        canvas.drawHierarchy(in: canvas.bounds, afterScreenUpdates: true)
        let canvasScreenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return canvasScreenshot
    }
    
    private func saveScreenshot() {
        if let screenshot = canvasScreenshot() {
            UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(errorHandler(_:_:_:)), nil)
        }
    }
    
    @objc private func errorHandler(_ image: UIImage, _ didFinishSavingWithError: NSError?, _ contextInfo: UnsafeRawPointer) {
        if let error = didFinishSavingWithError {
            showAlert(alertTitle: "Save error", alertMessage: error.localizedDescription, alertStyle: .alert, [alertAction("OK", .default, nil)])
        } else {
            showAlert(alertTitle: "Succeed!", alertMessage: "Successfully saved!", alertStyle: .alert, [alertAction("OK", .default, nil)])
        }
    }
    
    private func sharePainting() {
        
        showActivityVC([canvasScreenshot()!]) { [weak self] (activityType, completed, items, error) in
            
            guard let self = self else { return }
            
            if !completed {
                print(error ?? "User canceled sharing.")
                return
            }
            self.showAlert(alertTitle: "Succeed!", alertMessage: "Successfully completed!", alertStyle: .alert, [self.alertAction("OK", .default, nil)])
        }
    }
    
    private func showActivityVC(_ activityItems: [Any], _ handler: UIActivityViewController.CompletionWithItemsHandler?) {
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [.assignToContact, .message, .mail, .addToReadingList, .openInIBooks, .markupAsPDF, .postToVimeo, .postToWeibo, .postToFlickr, .saveToCameraRoll]
        
        present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = handler
    }
    
    private func showAlert(alertTitle: String, alertMessage: String?, alertStyle: UIAlertController.Style, _ actions: [UIAlertAction]) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: alertStyle)
            
            for i in 0..<actions.count {
                alert.addAction(actions[i])
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func alertAction(_ actionTitle: String, _ actionStyle: UIAlertAction.Style, _ handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        
        let action = UIAlertAction(title: actionTitle, style: actionStyle, handler: handler)
        
        return action
    }
    
    private func showSaveScreenShotAlert() {
        showAlert(alertTitle: "Take a Screenshot?", alertMessage: nil, alertStyle: .alert, [alertAction("No", .default, nil), alertAction("Yes", .default, { [weak self] (_) in
            guard let self = self else { return }
            self.saveScreenshot()
        })])
    }
    
    private func showOpenAuthSettingAlert() {
        showAlert(alertTitle: "Saving photos is not permitted", alertMessage: "Go to check the Setting", alertStyle: .alert, [alertAction("Cancel", .default, nil), alertAction("Setting", .default, { [weak self] (_) in
            guard let self = self else { return }
            self.openAuthSetting()
        })])
    }
    
    private func openAuthSetting() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
}

extension PaintingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return colorsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as! ColorsCollectionViewCell
        cell.setView(colorsArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let color = colorsArray[indexPath.row]
        canvas.setBrushColor(color: color)
        selectBrushColorButton.backgroundColor = color
    }
}
