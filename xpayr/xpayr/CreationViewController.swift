//
//  CreationViewController.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    var item: Item?

    // MARK: - Actions
    @IBAction func saveItem(_ sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: ViewController = segue.destination as! ViewController
        destinationVC.items?.append(item!)
        print(item)
    }

    func textFieldDidChange(textField: UITextField){
        item?.name = textField.text!
    }
}
