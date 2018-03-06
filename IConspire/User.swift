//
//  User.swift
//  Conpiracy
//
//  Created by Demick McMullin on 5/4/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class User: Equatable {
    
    static let userNameKey = "userName"
    static let userrecordIDKey = "userRecordID"
    static let projectReferencesKey = "projectReferences"
    
    
    var userName: String
    var userID: CKRecordID?
    var projectReferences: [CKReference]?
    

    init(userName: String) {
    
        self.userName = userName
    
    }

    init?(record: CKRecord) {
        guard let userName = record[User.userNameKey] as? String else { return nil }
    
            self.userName = userName
            self.userID = record.recordID
            self.projectReferences = record[User.projectReferencesKey] as? [CKReference]
 
    }
    

} // end User Model Class

extension CKRecord {
    convenience init(user: User) {
        let userID = user.userID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: "User", recordID: userID)
        self.setValue(user.userName, forKey: User.userNameKey)
        self.setValue(user.projectReferences, forKey: User.projectReferencesKey)
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs === rhs
}


