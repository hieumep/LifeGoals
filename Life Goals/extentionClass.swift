//
//  extentionClass.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/27/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//
import UIKit

extension GoalViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Your goals description..." {
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Your goals description..."
        }
    }
}
