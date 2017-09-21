//
//  Item.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import Foundation
import UIKit

class Item: Codable {
    var name: String?
    var image: UIImage?
    var expirationDate: Date?

    func toDictionary() -> [String:Any] {
        return ["name": name, "image": image, "expirationDate": expirationDate]
    }
}
