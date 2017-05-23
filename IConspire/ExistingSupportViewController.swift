//
//  ExistingSupportViewController.swift
//  IConspire
//
//  Created by Demick McMullin on 5/10/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import UIKit

class ExistingSupportViewController: UIViewController {

    var support: Support?
    
    // MARK: - Outlets
    
    @IBOutlet weak var supportTitle: UITextField!
    @IBOutlet weak var supportSubTitle: UITextField!
    @IBOutlet weak var supportSource: UITextField!
    @IBOutlet weak var supportAuthor: UITextField!
    @IBOutlet weak var supportBody: UITextView!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    
    // MARK: - Actions
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        guard let support = support, let title = supportTitle.text, let subtitle = supportSubTitle.text, let source = supportSource.text, let author = supportAuthor.text, let body = supportBody.text else {return}
        support.supportTitle = title
        support.supportSubTitle = subtitle
        support.supportSource = source
        support.supportAuthor = author
        support.supportBody = body
        
        SupportController.shared.modifySupport(support: support) {
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        // Do any additional setup after loading the view.
    }

    func updateView() {
        guard let support = support else  {return}
        supportTitle.text = support.supportTitle
        supportSubTitle.text = support.supportSubTitle
        supportSource.text = support.supportSource
        supportAuthor.text = support.supportAuthor
        supportBody.text = support.supportBody
        
    }

    

}
