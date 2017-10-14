//
//  CreationViewController.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Properties
    var item: Item?

    // MARK: - Outlets
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var preview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        item = Item(name: nil, image: nil, expirationDate: nil)
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        picker.minimumDate = Date()
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }

    // MARK: - Actions
    @IBAction func saveItem(_ sender: AnyObject) {
        let destinationVC: ViewController = self.navigationController?.viewControllers.first as! ViewController
        destinationVC.add(item: item!)
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.navigationController?.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        item?.image = image
        preview.image = image
        preview.isHidden = false
        dismiss(animated:true, completion: nil)
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        item?.expirationDate = sender.date
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        item?.name = textField.text!
    }
}
