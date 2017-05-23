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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
       saveButtonTapped.isEnabled = false
        guard let projectTitle = projectTitle.text,
            let projectTheory = projectTheory.text else {return}
        ProjectController.shared.saveProject(projectTitle: projectTitle, projectTheory: projectTheory) { (_) in
  
        }
        sleep(2)
        let _ = self.navigationController?.popViewController(animated: true)
    }

}
