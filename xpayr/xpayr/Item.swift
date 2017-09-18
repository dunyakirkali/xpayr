//
//  Item.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit

class Item {
    var name: String
    var image: UIImage?
    var expirationDate: Date

    init(name: String, image: UIImage?, expirationDate: Date) {
        self.image = image
        self.name = name
        self.expirationDate = expirationDate
    }
}
