//
//  HomePageViewController.swift
//  Meme-Editor
//
//  Created by Manocha, Ankit Prem on 12/31/16.
//  Copyright © 2016 Manocha, Ankit Prem. All rights reserved.
//

import Foundation
import UIKit

class HomePageViewController: ViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var selectedImage:UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        ShareButton.isEnabled = false;
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func showCamera(_ sender: Any) {
        launchImageController(source: .camera)
    }
    
    @IBAction func showAlbum(_ sender: Any) {
        launchImageController(source: .photoLibrary)
    }
    
    func launchImageController(source: UIImagePickerControllerSourceType){
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = source
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageName = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        passOnImage(selectedImage: imageName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "editImage"){
            let controller = segue.destination as! EditMemeViewController
            controller.selectedImage = self.selectedImage
        }
        
    }
    
    func passOnImage(selectedImage:UIImage){
        self.selectedImage = selectedImage
        performSegue(withIdentifier: "editImage", sender: self)
    }
    
}
