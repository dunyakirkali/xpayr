//
//  ItemCell.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var img: UIImageView!

    var item: Item? {
        didSet {
            nameLabel.text = item?.name

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.locale = Locale.init(identifier: "nl_NL")
            expirationLabel.text = dateFormatter.string(from: (item?.expirationDate)!)

            img.image = item?.image
        }
    }
    
}
