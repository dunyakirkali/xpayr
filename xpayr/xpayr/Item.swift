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
import UserNotifications

class Item: Codable  {
    // MARK: - Properties
    var name: String
    var imagePath: String?
    var expirationDate: Date
    var UUID: String
    var notificationContent: String {
        return "\(name) is about to expire!"
    }
    
    // MARK: - Initializers
    init(name: String, imagePath: String?, expirationDate: Date, UUID: String) {
        self.name = name
        self.imagePath = imagePath
        self.expirationDate = expirationDate
        self.UUID = UUID
    }

    var hasExpired: Bool {
        return (Date().compare(self.expirationDate) == ComparisonResult.orderedDescending)
    }

    // MARK: - Deinitializer
    deinit {
        guard let imgPath = imagePath else { return }
        
        do {
            try Disk.remove(imgPath, from: .documents)
        } catch {
            print("Failed to remove image")
        }
    }
}
