//
//  NewSupportViewController.swift
//  IConspire
//
//  Created by Demick McMullin on 5/10/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import UIKit

class NewSupportViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    var project: Project?
  
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var supportImage: UIImageView!
    @IBOutlet weak var titleEntry: UITextField!
    @IBOutlet weak var subtitleEntry: UITextField!
    @IBOutlet weak var sourceEntry: UITextField!
    @IBOutlet weak var authorEntry: UITextField!
    @IBOutlet weak var supportBody: UITextView!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var latitudeEntry: UITextField!
    @IBOutlet weak var longitudeEntry: UITextField!
    
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        addPhotoActionSheet()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        SaveButton.isEnabled = false
        guard let latitudeAsDouble = latitudeEntry.text,
              let longitudeAsDouble = longitudeEntry.text
            else {return}
        
        guard let title = titleEntry.text,
            let subtitle = subtitleEntry.text,
            let source = sourceEntry.text,
            let author = authorEntry.text,
            let body = supportBody.text,
            let latitude = Double(latitudeAsDouble),
            let longitude = Double(longitudeAsDouble),
            let project = project,
            let image = supportImage.image
            else {return}
        
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
        SupportController.shared.saveSupport(supportTitle: title, supportSubTitle: subtitle, supportSource: source, supportAuthor: author, supportDate: Date(), supportBody: body, supportLatitude: latitude, supportLongitude: longitude, project: project, supportImageData: imageData) {  (_) in
            DispatchQueue.main.async {
                let _ = self.navigationController?.popViewController(animated: true)
            }
            }
        
        }
    }

// MARK: - Upload Image functions

func uploadButton() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .photoLibrary
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
}

func cameraButton() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .camera
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
}


func addPhotoActionSheet() {
    let actionController = UIAlertController(title: "Upload Photo", message: nil, preferredStyle: .actionSheet)
    let uploadAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
        self.uploadButton()
    }
    let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
        self.cameraButton()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)  &&  UIImagePickerController.isSourceTypeAvailable(.camera){
        actionController.addAction(uploadAction)
        actionController.addAction(cameraAction)
    } else if UIImagePickerController.isSourceTypeAvailable(.camera) {
        actionController.addAction(cameraAction)
    } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        actionController.addAction(uploadAction)
    }
    actionController.addAction(cancelAction)
    present(actionController, animated: true, completion: nil)
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
    supportImage.image = selectedImage
    addImageButton.setTitle("", for: .normal)
    dismiss(animated: true, completion: nil)
}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if supportBody.isFirstResponder {
            supportBody.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

}

