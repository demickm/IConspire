//
//  ExistingProjectViewController.swift
//  IConspire
//
//  Created by Demick McMullin on 5/10/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import UIKit

class ExistingProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cloudKitManager = CloudKitManager()
    var project: Project?
    
    
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectDate: UILabel!
    @IBOutlet weak var projectTheory: UITextView!
    @IBOutlet weak var projectSupport: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let project = project else {return}
        SupportController.shared.fetchSupport(project: project) { (_) in
            DispatchQueue.main.async {
                self.projectSupport.reloadData()
            }
        }
        updateView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.projectSupport.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let project = project, let title = projectTitle.text,
            let theory = projectTheory.text else {return}
        project.projectTitle = title
        project.projectTheory = theory
       
        ProjectController.shared.modifyProject(project: project) { 
            
        }
    }
    
    func updateView() {
        guard let project = project else {return}
        projectTitle.text = project.projectTitle
        projectDate.text = "Date Created: " + dateFormatter.string(from: project.projectCreationDate)
        projectTheory.text = project.projectTheory
        
    }
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SupportController.shared.support.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = projectSupport.dequeueReusableCell(withIdentifier: "supportCell", for: indexPath)
        
            let supportCell = SupportController.shared.support[indexPath.row]
            cell.textLabel?.text = supportCell.supportTitle
            cell.detailTextLabel?.text = supportCell.supportAuthor
            return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toNewSupport" {
            guard let destinationViewController = segue.destination as? NewSupportViewController,
                let project = project else {return}
                destinationViewController.project = project
            
        } else if segue.identifier == "toExistingSupport" {
            guard let destinationViewController = segue.destination as? ExistingSupportViewController,
            let indexPath = projectSupport.indexPathForSelectedRow
                else {return}
                let supportCell = SupportController.shared.support[indexPath.row]
                destinationViewController.support = supportCell
                
            }
        } // end toNewSupport

        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            formatter.doesRelativeDateFormatting = true
            return formatter
        }()

}
