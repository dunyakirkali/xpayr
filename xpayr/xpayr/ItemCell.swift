//
//  ItemCell.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit
import SwipeCellKit

class ItemCell: SwipeTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var container: UIView! {
        didSet {
            container.layer.shadowColor = UIColor.black.cgColor
            container.layer.shadowOpacity = 0.2
            container.layer.shadowOffset = CGSize.zero
            container.layer.shadowRadius = 10
        }
    }

    var item: Item? {
        didSet {
            nameLabel.text = item?.name

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.locale = Locale.current
            expirationLabel.text = dateFormatter.string(from: (item?.expirationDate)!)

            img.image = item?.image
        }
    }
    
}
