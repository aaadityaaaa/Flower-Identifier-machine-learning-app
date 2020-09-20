//
//  ViewController.swift
//  seeFood
//
//  Created by Aaditya Singh on 12/09/20.
//  Copyright © 2020 Aaditya Singh. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedimage
            
            guard let ciimage = CIImage(image: userPickedimage) else{
                fatalError("could not convert to ci image")
            }
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("coreml model failed")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("error doing this task")
            }
        }
        
         let handler = VNImageRequestHandler(ciImage: image)
        
        do{
        try handler.perform([request])
        }catch {
            print("error while performing tasks")
        }
        
    }
    
   
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    

}

