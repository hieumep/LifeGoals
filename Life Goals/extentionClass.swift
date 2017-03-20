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
    
    func tapHideKeyboard(){
        self.view.endEditing(true)
    }
    
    func addKeyboardDismissRecoginze() {
        self.view.addGestureRecognizer(tapGesture!)
    }
    
    func removeKeyboardDismissRecoginze() {
        self.view.removeGestureRecognizer(tapGesture!)
    }

    
}

extension DoneViewController : UITextViewDelegate, UIGestureRecognizerDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What do you got it after complete your goal ..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "What do you got it after complete your goal ..."
        }
    }
    
    func tapHideKeyboard(_ gesture : UIGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func addKeyboardDismissRecoginze() {
        self.view.addGestureRecognizer(tapGesture!)
    }
    
    func removeKeyboardDismissRecoginze() {
        self.view.removeGestureRecognizer(tapGesture!)
    }

    func longPressToSave(gestureRecognizer : UIGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            saveData()
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        doneButton.alpha = 0.3
        UIView.animate(withDuration: 3, animations: {
            self.doneButton.alpha = 1
        })
        return true
    }
}

extension NoteViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Your note description..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Your note description..."
        }
    }
}


