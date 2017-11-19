//
//  ItemCell.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit
import SwipeCellKit
import Disk
import Crashlytics

class ItemCell: SwipeTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var container: UIView! {
        didSet {
            container.layer.shadowColor = UIColor.flatBlue.cgColor
            container.layer.shadowOpacity = 0.2
            container.layer.shadowOffset = CGSize.zero
            container.layer.shadowRadius = 10
        }
    }

    var item: Item? {
        didSet {
            nameLabel.text = item?.name
            expirationLabel.text = item?.formattedDate

            if (item?.hasExpired)! {
                expirationLabel.textColor = UIColor.flatRed
            } else {
                expirationLabel.textColor = UIColor.flatBlack
            }

            guard let imgPath = item?.imagePath else {
                return
            }
            
            do {
                img.image = try Disk.retrieve(imgPath, from: .documents, as: UIImage.self)
            } catch let error {
                Crashlytics.sharedInstance().recordError(error)
            }
        }
    }
}
