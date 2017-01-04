//
//  EditMemeViewController.swift
//  Meme-Editor
//
//  Created by Manocha, Ankit Prem on 12/31/16.
//  Copyright © 2016 Manocha, Ankit Prem. All rights reserved.
//

import Foundation
import UIKit


class EditMemeViewController: ViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage:UIImage!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    
    weak var memedImage: UIImage!
    
    let default_top_text = "ENTER TOP TEXT HERE"
    let default_bottom_text = "ENTER BOTTOM TEXT HERE"
    let empty_text = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(selectedImage==nil) {
            showImagePicker()
        }
        manageTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        setDefaultValues()
    }

    
    @IBAction func showCamera(_ sender: Any) {
        launchImageController(source: .camera)
    }
    
    @IBAction func showAlbum(_ sender: Any) {
        launchImageController(source: .photoLibrary)
    }
    
    @IBAction func callShare(_ sender: Any) {
        let savedImage = generateMemedImage()
        self.memedImage = savedImage
        let controller = UIActivityViewController(activityItems: [savedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.save()
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelView(_ sender: Any) {
        setDefaultValues()
        showImagePicker()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setDefaultValues(){
        imageView.image = nil
        selectedImage = nil
        topText.text = default_top_text
        bottomText.text = default_bottom_text
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
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Arial-BoldMT", size: 40)!,
            NSStrokeWidthAttributeName : -4]
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
        if(bottomText.isEditing){
           view.frame.origin.y -= getKeyboardHeight(notification)
        }
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
        if(textField == topText){
            view.frame.origin.y = 0
        }
        if((textField == topText && textField.text == default_top_text) || (textField == bottomText && textField.text == default_bottom_text)){
            textField.text = empty_text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func launchImageController(source: UIImagePickerControllerSourceType){
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = source
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageName = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImage = imageName
        showTextEditor()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showImagePicker(){
        ShareButton.isEnabled = false;
        cancelButton.isEnabled = false;
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topText.isHidden = true
        bottomText.isHidden = true
        albumButton.isEnabled = true
    }
    
    func showTextEditor(){
        cameraButton.isEnabled = false
        albumButton.isEnabled = false
        self.topText.isHidden = false
        self.bottomText.isHidden = false
        self.cancelButton.isEnabled = true
        self.ShareButton.isEnabled = true
        showSelectedImageInTheBack()
    }
    
    func manageTextFields(){
        manageTextAttributes()
        subscribeToKeyboardNotifications()
        topText.delegate = self
        bottomText.delegate = self
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
    }

    
}

