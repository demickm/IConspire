//
//  UserController.swift
//  IConspire
//
//  Created by Demick McMullin on 5/8/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    static let shared = UserController()
    
    var currentUser: User?
    var cloudKitManager = CloudKitManager()
    
 
    func saveUser(userName: String, completion: @escaping(User?) -> Void) {
        let user = User(userName: userName)
        let record = CKRecord(user: user)
        cloudKitManager.saveRecord(record) { (savedUserRecord, error) in
            if let error = error {
                print("Error with saving User to cloudkit: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let savedUserRecord = savedUserRecord else { completion(nil); return }
            let user = User(record: savedUserRecord)
            self.currentUser = user
            completion(user)
        }
    }

    func modifyUser(user: User, completion: @escaping () -> Void) {
        let record = CKRecord(user: user)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.completionBlock = {
            completion()
        }
        operation.savePolicy = .changedKeys
        self.cloudKitManager.publicDatabase.add(operation)
    }
}

