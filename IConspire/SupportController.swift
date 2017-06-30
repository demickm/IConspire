//
//  SupportController.swift
//  IConspire
//
//  Created by Demick McMullin on 5/10/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import Foundation
import CloudKit

class SupportController {
  
    static let shared = SupportController()
   
    var cloudKitManager = CloudKitManager()
    var support: [Support] = []
    
    func fetchSupport(project: Project, completion: @escaping([Support]) -> Void){
        cloudKitManager.fetchProjectSupport(project: project) { (support) in
            guard let support = support else {return}
            self.support = support
            completion(support)
        }
    }
    
    
    func saveSupport(supportTitle: String, supportSubTitle: String, supportSource: String, supportAuthor: String, supportDate: Date, supportBody: String, supportLatitude: Double, supportLongitude: Double, project: Project, completion: @escaping(Support?) -> Void) {
        guard let projectID = project.projectID else { completion(nil); return }
        let projectReference = CKReference(recordID: projectID, action: .deleteSelf)
        let support = Support(supportTitle: supportTitle, supportSubTitle: supportSubTitle, supportSource: supportSource, supportAuthor: supportAuthor, supportDate: supportDate, supportBody: supportBody, supportLatitude: supportLatitude, supportLongitude: supportLongitude, projectReference: projectReference)
        let record = CKRecord(support: support)
        cloudKitManager.saveRecord(record) { (savedSupportFile, error) in
            if let error = error {
                print("Error with saving Support File to cloudKit: \(error.localizedDescription)")
                completion(nil)
                return
            } else {
                guard let savedSupportRecord = savedSupportFile else { completion(nil); return}
                print("Saved Support File to CloudKit")
                let savedSupport = Support(record: savedSupportRecord)
                self.support.append(support)
                completion(savedSupport)
            }
        }
    }
    
    func modifySupport(support: Support, completion: @escaping () -> Void) {
        let record = CKRecord(support: support)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.completionBlock = {
            completion()
        }
        operation.savePolicy = .changedKeys
        self.cloudKitManager.publicDatabase.add(operation)
    }
    
}

