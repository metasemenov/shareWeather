//
//  OutlinedLabel.swift
//  ShareWeather
//
//  Created by Admin on 16.11.16.
//  Copyright © 2016 EvilMind. All rights reserved.
//

import UIKit

class OutlinedLabel: UILabel {

    var outlineWidth: CGFloat = 2
    var outlineColor: UIColor = UIColor.black
    
    override func drawText(in rect: CGRect) {
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : outlineColor,
            NSStrokeWidthAttributeName : -1 * outlineWidth,
            ] as [String : Any]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}
