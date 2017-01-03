//
//  EditMemeViewController.swift
//  Meme-Editor
//
//  Created by Manocha, Ankit Prem on 12/31/16.
//  Copyright © 2016 Manocha, Ankit Prem. All rights reserved.
//

import Foundation
import UIKit

class EditMemeViewController: ViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage:UIImage!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    
    let DEFAULT_TOP_TEXT = "ENTER TOP TEXT HERE"
    let DEFAULT_BOTTOM_TEXT = "ENTER BOTTOM TEXT HERE"
    let EMPTY_TEXT = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = false
        albumButton.isEnabled = false
        showSelectedImageInTheBack()
        manageTextAttributes()
        subscribeToKeyboardNotifications()
        topText.delegate = self
        bottomText.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        topText.text = DEFAULT_TOP_TEXT
        bottomText.text = DEFAULT_BOTTOM_TEXT
    }
    
    @IBAction func callShare(_ sender: Any) {
        let savedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [savedImage], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func generateMemedImage() -> UIImage {
        
        navbar.isHidden = true
        toolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navbar.isHidden = false
        toolbar.isHidden = false
        
        return memedImage
    }
    
    func manageTextAttributes(){
        let memeTextAttributes:[String:Any] = [
            NSForegroundColorAttributeName: UIColor.white,
            NSStrokeColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Arial-BoldMT", size: 40)!]
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        bottomText.textAlignment = .center

    }
    
    func showSelectedImageInTheBack(){
        imageView.image = selectedImage
        view.bringSubview(toFront: topText)
        view.bringSubview(toFront: bottomText)
        view.bringSubview(toFront: navbar)
        view.bringSubview(toFront: toolbar)
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
       view.frame.origin.y -= getKeyboardHeight(notification)
    //bottomText.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
        //bottomText.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if((textField == topText && textField.text == DEFAULT_TOP_TEXT) || (textField == bottomText && textField.text == DEFAULT_BOTTOM_TEXT)){
            textField.text = EMPTY_TEXT
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

