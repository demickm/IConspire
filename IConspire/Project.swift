//
//  Project.swift
//  Conpiracy
//
//  Created by Demick McMullin on 5/3/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import Foundation
import CloudKit

class Project: Equatable {
    
    // MARK: - Keys
    
    static let projectTitleKey = "projectTitle"
    static let projectCreationDateKey = "projectCreationDate"
    static let projectTheoryKey = "projectTheory"
    static let isPublicKey = "isPublic"
    static let projectSupportKey = "projectSupport"
    
    // MARK: - Properties
    
    var projectTitle: String
    let projectCreationDate: Date
    var projectTheory: String
    var isPublic: Bool
    var projectID: CKRecordID?

    init(projectTitle: String, projectCreationDate: Date = Date(), projectTheory: String, isPublic: Bool = true) {
    
        self.projectTitle = projectTitle
        self.projectCreationDate = projectCreationDate
        self.projectTheory = projectTheory
        self.isPublic = isPublic
    
    }

    init?(record: CKRecord) {
        guard let projectTitle = record[Project.projectTitleKey] as? String,
            let projectCreationDate = record[Project.projectCreationDateKey] as? Date,
            let projectTheory = record[Project.projectTheoryKey] as? String,
            let isPublic = record[Project.isPublicKey] as? Bool
            else { return nil }
      
        self.projectTitle = projectTitle
        self.projectCreationDate = projectCreationDate
        self.projectTheory = projectTheory
        self.isPublic = isPublic
        self.projectID = record.recordID
        
    }
    
} // End Project Model Class


extension CKRecord {
    convenience init(project: Project) {
        let projectID = project.projectID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: "Project", recordID: projectID)
        self.setValue(project.projectTitle, forKey: Project.projectTitleKey)
        self.setValue(project.projectCreationDate, forKey: Project.projectCreationDateKey)
        self.setValue(project.projectTheory, forKey: Project.projectTheoryKey)
        self.setValue(project.isPublic, forKey: Project.isPublicKey)
      

    }
}


func ==(lhs: Project, rhs: Project) -> Bool {
    return lhs === rhs
}
