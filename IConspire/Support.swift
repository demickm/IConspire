//
//  Support.swift
//  Conpiracy
//
//  Created by Demick McMullin on 5/3/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

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
    static let supportImageDataKey = "supportImageData"
   
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
    var supportImageData: Data
    
    fileprivate var temporaryPhotoURL: URL {
        let tempDir = NSTemporaryDirectory()
        let tempURL = URL(fileURLWithPath: tempDir)
        let fileURL = tempURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")
        try? supportImageData.write(to: fileURL, options: [.atomic])
        return fileURL
    }
    
    var supportImage: UIImage {
        let imageData = supportImageData
        guard let image = UIImage(data: imageData) else { return UIImage() }
        return image
    }


    init(supportTitle: String, supportSubTitle: String, supportSource: String, supportAuthor: String, supportDate: Date, supportBody: String, supportLatitude: Double = 0.0, supportLongitude: Double = 0.0, projectReference: CKReference, supportImageData: Data) {
        
        self.supportTitle = supportTitle
        self.supportSubTitle = supportSubTitle
        self.supportSource = supportSource
        self.supportAuthor = supportAuthor
        self.supportDate = supportDate
        self.supportBody = supportBody
        self.supportLatitude = supportLatitude
        self.supportLongitude = supportLongitude
        self.projectReference = projectReference
        self.supportImageData = supportImageData
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
            let projectReference = record[Support.projectReferenceKey] as? CKReference,
            let photoAsset = record[Support.supportImageDataKey] as? CKAsset
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
        let imageDataOpt = try? Data(contentsOf: photoAsset.fileURL)
        guard let imageData = imageDataOpt else { return nil }
        self.supportImageData = imageData
    
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
        let imageAsset = CKAsset(fileURL: support.temporaryPhotoURL)
        self.setValue(imageAsset, forKey: Support.supportImageDataKey)
    
    }
}


func ==(lhs: Support, rhs: Support) -> Bool {
    return lhs === rhs
}
