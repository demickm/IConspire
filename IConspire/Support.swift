//
//  Support.swift
//  Conpiracy
//
//  Created by Demick McMullin on 5/3/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import Foundation
import CloudKit

class Support: Equatable {
    
    // MARK: - Keys
    
    static let supportTitleKey = "supportTitle"
    static let supportSubTitleKey = "supportSubTitle"
    static let supportSourceKey = "supportSourceKey"
    static let supportAuthorKey = "supportAuthor"
    static let supportDateKey = "supportDate"
    static let supportBodyKey = "supportBody"
    static let supportLatitudeKey = "supportLatitude"
    static let supportLongitudeKey = "supportLongitude"
    static let projectReferenceKey = "projectReference"
 
    // MARK: - Properties
    
    var supportTitle: String
    var supportSubTitle: String
    var supportSource: String
    var supportAuthor: String
    let supportDate: Date
    var supportBody: String
    var supportLatitude: Double
    var supportLongitude: Double
    var supportID: CKRecordID?
    let projectReference: CKReference
    
    init(supportTitle: String, supportSubTitle: String, supportSource: String, supportAuthor: String, supportDate: Date, supportBody: String, supportLatitude: Double, supportLongitude: Double, projectReference: CKReference) {
        
        self.supportTitle = supportTitle
        self.supportSubTitle = supportSubTitle
        self.supportSource = supportSource
        self.supportAuthor = supportAuthor
        self.supportDate = supportDate
        self.supportBody = supportBody
        self.supportLatitude = supportLatitude
        self.supportLongitude = supportLongitude
        self.projectReference = projectReference
    }
    
    
    init?(record: CKRecord) {
        guard let supportTitle = record[Support.supportTitleKey] as? String,
            let supportSubTitle = record[Support.supportSubTitleKey] as? String,
            let supportSource = record[Support.supportSourceKey] as? String,
            let supportAuthor = record[Support.supportAuthorKey] as? String,
            let supportDate = record[Support.supportDateKey] as? Date,
            let supportBody = record[Support.supportBodyKey] as? String,
            let supportLatitude = record[Support.supportLatitudeKey] as? Double,
            let supportLongitude = record[Support.supportLongitudeKey] as? Double,
            let projectReference = record[Support.projectReferenceKey] as? CKReference
            else { return nil }
        
        self.supportTitle = supportTitle
        self.supportSubTitle = supportSubTitle
        self.supportSource = supportSource
        self.supportAuthor = supportAuthor
        self.supportDate = supportDate
        self.supportBody = supportBody
        self.supportLatitude = supportLatitude
        self.supportLongitude = supportLongitude
        self.supportID = record.recordID
        self.projectReference = projectReference
    }

} // End Support Model Class


extension CKRecord {
    convenience init(support: Support) {
        let supportID = support.supportID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: "Support", recordID: supportID)
        self.setValue(support.supportTitle, forKey: Support.supportTitleKey)
        self.setValue(support.supportSubTitle, forKey: Support.supportSubTitleKey)
        self.setValue(support.supportSource, forKey: Support.supportSourceKey)
        self.setValue(support.supportAuthor, forKey: Support.supportAuthorKey)
        self.setValue(support.supportDate, forKey: Support.supportDateKey)
        self.setValue(support.supportBody, forKey: Support.supportBodyKey)
        self.setValue(support.supportLatitude, forKey: Support.supportLatitudeKey)
        self.setValue(support.supportLongitude, forKey: Support.supportLongitudeKey)
        self.setValue(support.projectReference, forKey: Support.projectReferenceKey)
    
    }
}


func ==(lhs: Support, rhs: Support) -> Bool {
    return lhs === rhs
}
