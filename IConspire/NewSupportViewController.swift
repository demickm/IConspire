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
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleEntry.text,
            let subtitle = subtitleEntry.text,
            let source = sourceEntry.text,
            let author = authorEntry.text,
            let body = supportBody.text,
            let project = project
            else {return}
        
        SupportController.shared.saveSupport(supportTitle: title, supportSubTitle: subtitle, supportSource: source, supportAuthor: author, supportDate: Date(), supportBody: body, project: project) {  (_) in
        
           
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
