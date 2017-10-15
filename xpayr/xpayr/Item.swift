//
//  Item.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import Foundation
import UIKit
import Disk

class Item: Codable  {
    // MARK: - Properties
    var name: String?
    var imagePath: String?
    var expirationDate: Date
    
    // MARK: - Initializers
    init(name: String?, imagePath: String?, expirationDate: Date) {
        self.name = name
        self.imagePath = imagePath
        self.expirationDate = expirationDate
    }

    // MARK: - Deinitializer
    deinit {
        guard let imgPath = imagePath else {
            return
        }
        
        do {
            print("Removed image")
            try Disk.remove(imgPath, from: .documents)
        } catch {
            print("Failed to remove image")
        }
    }
}
