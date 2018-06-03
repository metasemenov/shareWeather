//
//  MainVC.swift
//  ShareWeather
//
//  Created by Admin on 01.11.16.
//  Copyright © 2016 EvilMind. All rights reserved.
//

import UIKit



class MainVC: UIViewController, UIImagePickerControllerDelegate {
    @IBOutlet weak var snapView: UIView!

    @IBOutlet weak var currentImg: UIImageView!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var currentDateLbl: UILabel!
    @IBOutlet weak var currentCityLbl: UILabel!
    @IBOutlet weak var mainText: UILabel!
   
    @IBOutlet weak var imageView: UIImageView!
    
   
    var saveImg: UIImage!
    var weather = Weather()
    
    var hud: MBProgressHUD = MBProgressHUD()
   
    var image: UIImage?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var outlineWidth: CGFloat = 2
    var outlineColor: UIColor = UIColor.black
    //Current date
    let date = Date()
    var calendar = NSCalendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // imageView.image = image
        // set date
        let month = calendar.dateComponents([.month], from: date).month!
        let day = calendar.dateComponents([.day], from: date).day!
        let char: Character = "."
        currentDateLbl.text = ("\(day)\(char)\(month)")
        
        
        self.navigationController?.navigationBar.isHidden = true
//        if let validImage = self.image {
//            self.imageView.image = validImage
//            
//        }
        weather.loadWeatherData(lat: currentCoord.latitude, lon: currentCoord.longitude, completed: {
            self.updateUI()
            
            
            
            let snap = self.textToImage(drawText: self.currentTempLbl.text!, inImage: self.image!, atPoint: CGPoint(x: (self.image?.size.width)! * 0.05, y: (self.image?.size.height)! * 0.05), name: "AvenirNext-Bold", size: 600)
            let finalsnap = self.textToImage(drawText: "\(self.currentCityLbl.text!) \(self.currentDateLbl.text!)", inImage: snap, atPoint: CGPoint(x: 100, y: (self.image?.size.height)! * 0.9), name: "AvenirNext-DemiBold", size: 200)
            self.imageView.image = finalsnap
             self.saveImg = finalsnap
             
        })
       
        
      
    }
    


    func updateUI() {
        
        currentTempLbl.text = "\(weather.currentTemp)°"
        currentImg.image = UIImage(named: "\(weather.currentIconName)")
        currentCityLbl.text = currentCity
        
    }
    
    @IBAction func backButtPressed(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func saveButtPressed(_ sender: Any) {
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        spinnerActivity.label.text = "Сохранение..."
        spinnerActivity.isUserInteractionEnabled = false
        
        DispatchQueue.global().async {
            
//            let newImage = self.textToImage(drawText: self.currentTempLbl.text!, inImage: self.image!, atPoint: CGPoint(x: 100, y: 100), name: "AvenirNext-Bold", size: 600)
//            let resultImg = self.textToImage(drawText: "\(self.currentCityLbl.text!) \(self.currentDateLbl.text!)", inImage: newImage, atPoint: CGPoint(x: 100, y: (self.image?.size.height)! * 0.9), name: "AvenirNext-DemiBold", size: 200)
            
            
            
            let savingImg = self.snapImg()

            UIImageWriteToSavedPhotosAlbum( savingImg , self, nil, nil)

            DispatchQueue.main.async {
                spinnerActivity.hide(animated: true)
                self.checkHud()
            }
        }
    }
    
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint, name: String, size: CGFloat) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: name, size: size)!
        
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            NSStrokeColorAttributeName : outlineColor,
            NSStrokeWidthAttributeName : -1 * outlineWidth,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size ))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
       
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func checkHud() {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .customView
        let imageHUD = UIImage(named: "Checkmark")
        hud.isSquare = true
        hud.customView = UIImageView(image: imageHUD)
        hud.label.text = "Сохранено"
        hud.hide(animated: true, afterDelay: 1)
    }
    
    func snapImg() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.snapView.bounds.size, false, UIScreen.main.scale)
       // UIGraphicsBeginImageContext(self.snapView.bounds.size)
        self.snapView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        return snap!
    }
    
    
}




