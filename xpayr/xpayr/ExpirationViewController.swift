//
//  ExpirationViewController.swift
//  xpayr
//
//  Created by Dunya Kirkali on 18/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit

class ExpirationViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var picker: UIDatePicker!

    // MARK: - Properties
    var item: Item?

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.minimumDate = Date()
        item = Item(name: "", image: nil, expirationDate: Date())
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: ImageViewController = segue.destination as! ImageViewController
        destinationVC.item = item
        print(item)
    }
}
