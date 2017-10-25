//
//  ItemCell.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit
import Cards
import SwipeCellKit
import Disk

class ItemCell: SwipeTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var card: CardGroup!
    
    var item: Item? {
        didSet {
            card.blurEffect = .prominent
            card.title = item?.name ?? ""

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.locale = Locale.current
            card.subtitle = dateFormatter.string(from: (item?.expirationDate)!)

            guard let imgPath = item?.imagePath else {
                return
            }

            do {
                card.backgroundImage = try Disk.retrieve(imgPath, from: .documents, as: UIImage.self)
            } catch {
                print("Could not retrieve image")
            }
        }
    }
    
}
