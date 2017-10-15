//
//  Item.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import Foundation
import UIKit

struct Item: Codable  {
    // MARK: - Properties
    var name: String?
    var imagePath: String?
    var expirationDate: Date
}
