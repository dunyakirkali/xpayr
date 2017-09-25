//
//  Item.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import Foundation
import UIKit

class Item: NSObject, NSCoding  {
    // MARK: - Properties
    var name: String?
    var image: UIImage?
    var expirationDate: Date?

    struct Keys {
        static let name = "name"
        static let image = "image"
        static let expirationDate = "expirationDate"
    }

    // MARK: - Initializers
    init(name: String?, image: UIImage?, expirationDate: Date?) {
        self.name = name
        self.image = image
        self.expirationDate = expirationDate
    }

    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: Keys.name) as? String ?? nil
        if let imageData: Data = aDecoder.decodeObject(forKey: Keys.image) as? Data {
            self.image = UIImage(data: imageData)
        }
        self.expirationDate = aDecoder.decodeObject(forKey: Keys.expirationDate) as? Date ?? nil
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.name)
        if let img: UIImage = image {
            aCoder.encode(UIImagePNGRepresentation(img), forKey: Keys.image)
        }
        aCoder.encode(expirationDate, forKey: Keys.expirationDate)
    }
}
