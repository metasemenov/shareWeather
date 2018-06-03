//
//  CameraVC.swift
//  ShareWeather
//
//  Created by Admin on 16.11.16.
//  Copyright © 2016 EvilMind. All rights reserved.
//

import UIKit
import CameraManager

class CameraVC: UIViewController {

    let cameraManager = CameraManager()
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var changeCameraBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var changeBtn: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    let cameraImg = UIImage(named: "takePhoto")
    let videoImg = UIImage(named: "videoPlay")
    let stopImg = UIImage(named: "stop")
    
    var hud: MBProgressHUD = MBProgressHUD()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
       // UIDevice.current.orientation = .portrait

        changeBtn.imageView?.contentMode = .scaleAspectFit
        changeCameraBtn.imageView?.contentMode = .scaleAspectFit
        
        cameraManager.showAccessPermissionPopupAutomatically = true
        
        addCameraToView()
        cameraManager.cameraOutputQuality = .high
        
        
       

    }

    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        cameraManager.stopCaptureSession()
    }

    
    fileprivate func addCameraToView() {
       _ = cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.stillImage)
                cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    

    @IBAction func recordButtonTapped(_ sender: UIButton) {
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.isUserInteractionEnabled = false
        
        switch (cameraManager.cameraOutputMode) {
        case .stillImage:
            cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
                if let errorOccured = error {
                    self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
                }
                else {
                    let vc: MainVC? = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as? MainVC
                    if let validVC: MainVC = vc {
                        if let capturedImage = image {
                            validVC.image = capturedImage
                            self.navigationController?.pushViewController(validVC, animated: true)
                            spinnerActivity.hide(animated: true)
                        }
                    }
                }
            })
        case .videoWithMic, .videoOnly:
           
            if sender.isSelected {
                cameraManager.startRecordingVideo()
               sender.setImage(stopImg, for: UIControlState())
            } else {
                
                cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
                    if let errorOccured = error {
                        self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
                    }
                  
                })
            }
            
        }
        
    
            }
    
    @IBAction func changeCameraVideo(_ sender: Any) {
        cameraManager.cameraOutputMode = cameraManager.cameraOutputMode == CameraOutputMode.stillImage ? CameraOutputMode.videoWithMic : CameraOutputMode.stillImage
      
        switch (cameraManager.cameraOutputMode) {
        case .stillImage:
          print("camera")
          playBtn.setImage(cameraImg, for: UIControlState())
             changeBtn.setImage(UIImage(named: "video"), for: UIControlState())
        case .videoWithMic, .videoOnly:
            print("video")
            playBtn.setImage(videoImg, for: UIControlState())
            changeBtn.setImage(UIImage(named: "camera"), for: UIControlState())
            
        }

        
    }

    @IBAction func changeCamera(_ sender: Any) {
        
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
        switch (cameraManager.cameraDevice) {
        case .front:
            print("front")
        case .back:
            print("back")
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}
