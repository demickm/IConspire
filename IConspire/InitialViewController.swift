//
//  InitialViewController.swift
//  IConspire
//
//  Created by Demick McMullin on 5/8/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cloudKitManager = CloudKitManager()
    var hasAlias: Bool = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var alias: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var myProjects: UITableView!
    
    @IBOutlet weak var databaseComunicationIndiicator: UIActivityIndicatorView!
    // MARK: - Actions
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let alias = alias.text, let user = user else {return}
        submitButton.isEnabled = false
        self.alias.isEnabled = false
        databaseComunicationIndiicator.startAnimating()
        if hasAlias == false {
            UserController.shared.saveUser(userName: alias) { (user) in
                self.user = user
                self.submitButton.isEnabled = true
                self.alias.isEnabled = true
                self.databaseComunicationIndiicator.stopAnimating()
                }
        } else {
            user.userName = alias
            UserController.shared.modifyUser(user: user) { 
                self.submitButton.isEnabled = true
                self.alias.isEnabled = true
                self.databaseComunicationIndiicator.stopAnimating()
            }
        }
    }

    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        guard let user = user else {
            self.submitButton.isEnabled = true
            self.alias.isEnabled = true
            hasAlias = false
            return }
        alias.text = user.userName
        hasAlias = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseComunicationIndiicator.startAnimating()
        cloudKitManager.fetchCurrentUser { (user) in
            DispatchQueue.main.async {
                self.user = user
            }
        }
        
        ProjectController.shared.fetchProjects { 
            DispatchQueue.main.async {
                self.myProjects.reloadData()
                print("fetched")
                self.databaseComunicationIndiicator.stopAnimating()
            }
        }
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SupportController.shared.support = []
        self.myProjects.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return ProjectController.shared.usersProjects.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myProjects.dequeueReusableCell(withIdentifier: "myExistingProjects", for: indexPath)
            let project = ProjectController.shared.usersProjects[indexPath.row]
            cell.textLabel?.text = project.projectTitle
            cell.detailTextLabel?.text = dateFormatter.string(from: project.projectCreationDate)
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let project = ProjectController.shared.usersProjects[indexPath.row]
            guard let recordID = project.projectID else {return}
            ProjectController.shared.delete(withRecordID: recordID, completion: {
            })
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "toMyProject" {
            guard let destinationViewController = segue.destination as? ExistingProjectViewController,
                let indexPath = myProjects.indexPathForSelectedRow
            else {return}
                let project = ProjectController.shared.usersProjects[indexPath.row]
            
            destinationViewController.project = project
            
        }
    }
    
    // MARK: - Date Formatter
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
}

