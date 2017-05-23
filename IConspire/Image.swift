//
//  Image.swift
//  Conpiracy
//
//  Created by Demick McMullin on 5/3/17.
//  Copyright © 2017 Demick McMullin. All rights reserved.
//

import Foundation
import UIKit

class Image {
    
    let image: UIImage
    let imageDate: Date?
    
    init(image: UIImage, imageDate: Date?) {
        
        self.image = image
        self.imageDate = imageDate
        
    }
}
