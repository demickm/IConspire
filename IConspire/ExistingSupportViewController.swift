//
//  ExistingSupportViewController.swift
//  IConspire
//
//  Created by Demick McMullin on 5/10/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import UIKit

class ExistingSupportViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var support: Support?
    
    // MARK: - Outlets
    
    @IBOutlet weak var supportTitle: UITextField!
    @IBOutlet weak var supportSubTitle: UITextField!
    @IBOutlet weak var supportSource: UITextField!
    @IBOutlet weak var supportAuthor: UITextField!
    @IBOutlet weak var supportBody: UITextView!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var supportDate: UITextField!
    @IBOutlet weak var latitudeEntry: UITextField!
    @IBOutlet weak var longitudeEntry: UITextField!
    @IBOutlet weak var supportImage: UIImageView!
   
    @IBOutlet weak var databaseCommunicationIndicator: UIActivityIndicatorView!
    // MARK: - Actions
    
    @IBAction func updateButtonTapped(_ sender: Any) {
       updateFile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        supportDate.isEnabled = false
        databaseCommunicationIndicator.stopAnimating()
        // Do any additional setup after loading the view.
    }
    
    func viewWillDisappear() {
        updateFile()
        
    }

    func updateView() {
        guard let support = support else  {return}
        supportTitle.text = support.supportTitle
        supportSubTitle.text = support.supportSubTitle
        supportSource.text = support.supportSource
        supportAuthor.text = support.supportAuthor
        supportBody.text = support.supportBody
        supportDate.text = dateFormatter.string(from: support.supportDate)
        latitudeEntry.text = "\(support.supportLatitude)"
        longitudeEntry.text = "\(support.supportLongitude)"
        supportImage.image = support.supportImage
    }
    
    func updateFile(){
        databaseCommunicationIndicator.startAnimating()
        guard let latitudeAsDouble = latitudeEntry.text,
            let longitudeAsDouble = longitudeEntry.text
            else {return}
    
        guard let support = support,
            let title = supportTitle.text,
            let subtitle = supportSubTitle.text,
            let source = supportSource.text,
            let author = supportAuthor.text,
            let body = supportBody.text,
            let latitude = Double(latitudeAsDouble),
            let longitude = Double(longitudeAsDouble)
            else {return}
    
        support.supportTitle = title
        support.supportSubTitle = subtitle
        support.supportSource = source
        support.supportAuthor = author
        support.supportBody = body
        support.supportLatitude = latitude
        support.supportLongitude = longitude
        SupportController.shared.modifySupport(support: support) {
            self.databaseCommunicationIndicator.stopAnimating()
    }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if supportTitle.isFirstResponder {
            supportSubTitle.becomeFirstResponder()
        } else if supportSubTitle.isFirstResponder {
            supportSource.becomeFirstResponder()
        } else if supportSource.isFirstResponder {
            supportAuthor.becomeFirstResponder()
        } else if supportAuthor.isFirstResponder {
            latitudeEntry.becomeFirstResponder()
        } else if latitudeEntry.isFirstResponder {
            longitudeEntry.becomeFirstResponder()
        } else if longitudeEntry.isFirstResponder {
            supportBody.becomeFirstResponder()
        }
        
        return true
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        supportBody.resignFirstResponder()
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()

}
