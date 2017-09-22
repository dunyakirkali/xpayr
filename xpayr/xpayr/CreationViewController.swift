//
//  CreationViewController.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {
    // MARK: - Properties
    var item: Item?

    @IBOutlet weak var field: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    func textFieldDidChange(_ textField: UITextField) {
        item?.name = textField.text!
    }

    // MARK: - Actions
    @IBAction func saveItem(_ sender: AnyObject) {
        let destinationVC: ViewController = self.navigationController?.viewControllers.first as! ViewController
        destinationVC.add(item: item!)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
