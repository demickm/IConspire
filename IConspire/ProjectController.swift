//
//  ProjectController.swift
//  IConspire
//
//  Created by Demick McMullin on 5/9/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import Foundation
import CloudKit

class ProjectController {
    
    var cloudKitManager = CloudKitManager()
    var usersProjects = [Project]()
    var publicProjects = [Project]()
    static let shared = ProjectController()
    
    
    func fetchPublicProjects(copletion: @escaping() -> Void){
        
    }
    
    func fetchProjects(completion: @escaping() -> Void){
        cloudKitManager.fetchUserProjects { (projects) in
            guard let projects = projects else {return}
            self.usersProjects = projects
            completion()
        }
        
    }
    
    func saveProject(projectTitle: String, projectTheory: String, completion: @escaping(Project?) -> Void) {
        let project = Project(projectTitle: projectTitle, projectTheory: projectTheory)
        let record = CKRecord(project: project)
        cloudKitManager.saveRecord(record) { (savedProjectRecord, error) in
            if let error = error {
                print("Error with saving Project to cloudkit: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let savedProjectRecord = savedProjectRecord else { completion(nil); return }
            guard let project = Project(record: savedProjectRecord) else {return}
            self.usersProjects.append(project)
            completion(project)
        }
      
    }
    
    func delete(withRecordID recordID: CKRecordID, completion: @escaping () -> Void) {
        guard let projectIndex = usersProjects.index(where: {$0.projectID == recordID }) else { completion(); return }
        usersProjects.remove(at: projectIndex)
        cloudKitManager.deleteRecordWithID(recordID) { (_, error) in
            if let error = error {
                print("Error with deleting question for topic: \(error.localizedDescription)")
                completion()
                return
            }
            print("Deleted Successfully")
        }
    }
    
    func modifyProject(project: Project, completion: @escaping () -> Void) {
        let record = CKRecord(project: project)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.completionBlock = {
            completion()
        }
        operation.savePolicy = .changedKeys
        self.cloudKitManager.publicDatabase.add(operation)
    }
    
}
