//
//  CustomTextView.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/13/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextView : UITextView {
    @IBInspectable var cornerRadius : CGFloat = 1.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.gray {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
}
