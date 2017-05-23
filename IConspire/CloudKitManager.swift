//
//  CloudKitManager.swift
//  IConspire
//
//  Created by Demick McMullin on 5/8/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//


import Foundation
import UIKit
import CloudKit

private let CreatorUserRecordIDKey = "creatorUserRecordID"
private let LastModifiedUserRecordIDKey = "creatorUserRecordID"
private let CreationDateKey = "creationDate"


class CloudKitManager {
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    init() {
        checkCloudKitAvailability()
    }
    
    // MARK: - User Info Discovery
    
    func fetchLoggedInUserRecord(_ completion: ((_ record: CKRecord?, _ error: Error? ) -> Void)?) {
        
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            
            if let error = error,
                let completion = completion {
                completion(nil, error)
            }
            
            if let recordID = recordID,
                let completion = completion {
                
                self.fetchRecord(withID: recordID, completion: completion)
            }
        }
    }
    
    
    
    // MARK: - Fetch Records
    
    func fetchRecord(withID recordID: CKRecordID, completion: ((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        
        publicDatabase.fetch(withRecordID: recordID) { (record, error) in
            
            completion?(record, error)
        }
    }
    
    func fetchRecordsWithType(_ type: String,
                              predicate: NSPredicate = NSPredicate(value: true),
                              recordFetchedBlock: ((_ record: CKRecord) -> Void)?,
                              completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        var fetchedRecords: [CKRecord] = []
        
        let query = CKQuery(recordType: type, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        let perRecordBlock = { (fetchedRecord: CKRecord) -> Void in
            fetchedRecords.append(fetchedRecord)
            recordFetchedBlock?(fetchedRecord)
        }
        queryOperation.recordFetchedBlock = perRecordBlock
        
        var queryCompletionBlock: (CKQueryCursor?, Error?) -> Void = { (_, _) in }
        
        queryCompletionBlock = { (queryCursor: CKQueryCursor?, error: Error?) -> Void in
            
            if let queryCursor = queryCursor {
                // there are more results, go fetch them
                
                let continuedQueryOperation = CKQueryOperation(cursor: queryCursor)
                continuedQueryOperation.recordFetchedBlock = perRecordBlock
                continuedQueryOperation.queryCompletionBlock = queryCompletionBlock
                
                self.publicDatabase.add(continuedQueryOperation)
                
            } else {
                completion?(fetchedRecords, error)
            }
        }
        queryOperation.queryCompletionBlock = queryCompletionBlock
        
        self.publicDatabase.add(queryOperation)
    }

    // MARK: - Delete
    
    func deleteRecordWithID(_ recordID: CKRecordID, completion: ((_ recordID: CKRecordID?, _ error: Error?) -> Void)?) {
        
        publicDatabase.delete(withRecordID: recordID) { (recordID, error) in
            completion?(recordID, error)
        }
    }
    
    func deleteRecordsWithID(_ recordIDs: [CKRecordID], completion: ((_ records: [CKRecord]?, _ recordIDs: [CKRecordID]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
        operation.savePolicy = .ifServerRecordUnchanged
        
        operation.modifyRecordsCompletionBlock = completion
        
        publicDatabase.add(operation)
    }
    
    
    // MARK: - Save and Modify
    
    
    func saveRecord(_ record: CKRecord, completion: ((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        
        publicDatabase.save(record, completionHandler: { (record, error) in
            completion?(record, error)
        })
    }

    
    func modifyRecords(_ records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        operation.perRecordCompletionBlock = perRecordCompletion
        
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) -> Void in
            (completion?(records, error))!
        }
        
        publicDatabase.add(operation)
    }

    // MARK: - CloudKit Permissions
    
    func checkCloudKitAvailability() {
        
        CKContainer.default().accountStatus() {
            (accountStatus:CKAccountStatus, error:Error?) -> Void in
            
            switch accountStatus {
            case .available:
                print("CloudKit available. Initializing full sync.")
                return
            default:
                self.handleCloudKitUnavailable(accountStatus, error: error)
            }
        }
    }
    
    func handleCloudKitUnavailable(_ accountStatus: CKAccountStatus, error:Error?) {
        
        var errorText = "Synchronization is disabled\n"
        if let error = error {
            print("handleCloudKitUnavailable ERROR: \(error)")
            print("An error occured: \(error.localizedDescription)")
            errorText += error.localizedDescription
        }
        
        switch accountStatus {
        case .restricted:
            errorText += "iCloud is not available due to restrictions"
        case .noAccount:
            errorText += "There is no CloudKit account setup.\nYou can setup iCloud in the Settings app."
        default:
            break
        }
        
        displayCloudKitNotAvailableError(errorText)
    }
    
    func displayCloudKitNotAvailableError(_ errorText: String) {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title: "iCloud Synchronization Error", message: errorText, preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
            
            alertController.addAction(dismissAction)
            
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    
    // MARK: - CloudKit Discoverability
    
    func requestDiscoverabilityPermission() {
        
        CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (permissionStatus, error) in
            
            if permissionStatus == .initialState {
                CKContainer.default().requestApplicationPermission(.userDiscoverability, completionHandler: { (permissionStatus, error) in
                    
                    self.handleCloudKitPermissionStatus(permissionStatus, error: error)
                })
            } else {
                
                self.handleCloudKitPermissionStatus(permissionStatus, error: error)
            }
        }
    }
    
    func handleCloudKitPermissionStatus(_ permissionStatus: CKApplicationPermissionStatus, error:Error?) {
        
        if permissionStatus == .granted {
            print("User Discoverability permission granted. User may proceed with full access.")
        } else {
            var errorText = "Synchronization is disabled\n"
            if let error = error {
                print("handleCloudKitUnavailable ERROR: \(error)")
                print("An error occured: \(error.localizedDescription)")
                errorText += error.localizedDescription
            }
            
            switch permissionStatus {
            case .denied:
                errorText += "You have denied User Discoverability permissions. You may be unable to use certain features that require User Discoverability."
            case .couldNotComplete:
                errorText += "Unable to verify User Discoverability permissions. You may have a connectivity issue. Please try again."
            default:
                break
            }
            
            displayCloudKitPermissionsNotGrantedError(errorText)
        }
    }
    
    func displayCloudKitPermissionsNotGrantedError(_ errorText: String) {
        
        DispatchQueue.main.async(execute: {
            
            let alertController = UIAlertController(title: "CloudKit Permissions Error", message: errorText, preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
            
            alertController.addAction(dismissAction)
            
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    // MARK: - Fetch Current User
    
    func fetchCurrentUser(completion: @escaping(User?) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (userID, error) in
            if let error = error { NSLog(error.localizedDescription) }
            
            guard let userID = userID else { return }
            
            let reference = CKReference(recordID: userID, action: .none)
            let predicate = NSPredicate(format: "creatorUserRecordID == %@", reference)
            let query = CKQuery(recordType: "User", predicate: predicate)
            
            self.publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error { print(error.localizedDescription) }
                
                guard let records = records else { return }
                let users = records.flatMap { User(record: $0) }
                let user = users[0]
                completion(user)
            })
        }
    }
    
    func fetchUserProjects(completion: @escaping([Project]?) -> Void) {
        
        CKContainer.default().fetchUserRecordID { (userID, error) in
            if let error = error { NSLog(error.localizedDescription) }
            
            guard let userID = userID else { return }
            
            let reference = CKReference(recordID: userID, action: .none)
            let predicate = NSPredicate(format: "creatorUserRecordID == %@", reference)
            let query = CKQuery(recordType: "Project", predicate: predicate)
            self.publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error { print(error.localizedDescription) }
                
                guard let records = records else { return }
                let projects:[Project] = records.flatMap { Project(record: $0) }
                completion(projects)
            })
        }
    }
    
    func fetchProjectSupport(project: Project, completion: @escaping([Support]?) -> Void) {
        
        guard let projectID = project.projectID else {return}
        
        let reference = CKReference(recordID: projectID, action: .none)
        let predicate = NSPredicate(format: "projectReference == %@", reference)
        let query = CKQuery(recordType: "Support", predicate: predicate)
        self.publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
            if let error = error { print(error.localizedDescription) }
            
            guard let records = records else { return }
            let support:[Support] = records.flatMap { Support(record: $0) }
            completion(support)
        })
    }

}

    
