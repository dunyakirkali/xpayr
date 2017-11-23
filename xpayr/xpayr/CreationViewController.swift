//
//  CreationViewController.swift
//  xpayr
//
//  Created by Dunya Kirkali on 17/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit
import Disk
import Crashlytics
import Firebase

class CreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Properties
    public var item: Item?

    // MARK: - Outlets
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var preview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRemoteConfigDefaults()
        
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        if let item = item {
            field.text = item.name
            picker.date = item.expirationDate
            if let imgPath = item.imagePath {
                do {
                    preview.image = try Disk.retrieve(imgPath, from: .documents, as: UIImage.self)
                    preview.isHidden = false
                } catch let error {
                    Crashlytics.sharedInstance().recordError(error)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchRemoteConfig()
        
        if RemoteConfig.remoteConfig().configValue(forKey: "allow_any_date").stringValue != "true" {
            picker.minimumDate = Date()
        }
    }

    // MARK: - Actions

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
        let imagePath: String = "Album/\(item!.UUID).jpeg"
        
        do {
            try Disk.save(image, to: .documents, as: imagePath)
        } catch let error {
            Crashlytics.sharedInstance().recordError(error)
        }
        item?.imagePath = imagePath
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
    
    func setupRemoteConfigDefaults() {
        let defaultValues = [
            "allow_any_date" : "true" as NSObject
        ]
        RemoteConfig.remoteConfig().setDefaults(defaultValues)
    }
    
    func fetchRemoteConfig() {
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 60) { (status, error) in
            guard error == nil else {
                print("Uh-oh. Got an error fetchin remote values: \(error)")
                return
            }
            RemoteConfig.remoteConfig().activateFetched()
        }
    }
}
