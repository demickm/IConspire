//
//  NewSupportViewController.swift
//  IConspire
//
//  Created by Demick McMullin on 5/10/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import UIKit

class NewSupportViewController: UIViewController {

    var project: Project?
  
    @IBOutlet weak var titleEntry: UITextField!
    @IBOutlet weak var subtitleEntry: UITextField!
    @IBOutlet weak var sourceEntry: UITextField!
    @IBOutlet weak var authorEntry: UITextField!
    @IBOutlet weak var supportBody: UITextView!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var latitudeEntry: UITextField!
    @IBOutlet weak var longitudeEntry: UITextField!
    
    
    
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
            let project = project
            else {return}
 
        SupportController.shared.saveSupport(supportTitle: title, supportSubTitle: subtitle, supportSource: source, supportAuthor: author, supportDate: Date(), supportBody: body, supportLatitude: latitude, supportLongitude: longitude, project: project) {  (_) in
            DispatchQueue.main.async {
                let _ = self.navigationController?.popViewController(animated: true)
            }
            }
        
        }

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
}

