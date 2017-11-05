//
//  NewProjectViewController.swift
//  IConspire
//
//  Created by Demick McMullin on 5/9/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import UIKit

class NewProjectViewController: UIViewController {

    @IBOutlet weak var projectTitle: UITextField!
    @IBOutlet weak var projectTheory: UITextView!
    @IBOutlet weak var saveButtonTapped: UIBarButtonItem!
    
    @IBOutlet weak var databaseCommunicationIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
       saveButtonTapped.isEnabled = false
        databaseCommunicationIndicator.isHidden = false
        databaseCommunicationIndicator.startAnimating()
        guard let projectTitle = projectTitle.text,
            let projectTheory = projectTheory.text else {return}
     ProjectController.shared.saveProject(projectTitle: projectTitle, projectTheory: projectTheory) { (project) in
        
        guard let project = project else {return}
        print ("saved \(project.projectTitle)")
        DispatchQueue.main.async {
            self.databaseCommunicationIndicator.stopAnimating()
            self.databaseCommunicationIndicator.isHidden = true
            let _ = self.navigationController?.popViewController(animated: true)
        }
        }
    }
 
   
    }
