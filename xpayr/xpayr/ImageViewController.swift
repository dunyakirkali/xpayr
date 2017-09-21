//
//  ImageViewController.swift
//  xpayr
//
//  Created by Dunya Kirkali on 18/09/2017.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit
import SwiftyCam

class ImageViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    // MARK: - Properties
    var item: Item?

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraDelegate = self

        let captureButton = SwiftyCamButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        captureButton.delegate = self
        view.addSubview(captureButton)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: CreationViewController = segue.destination as! CreationViewController
        destinationVC.item = item
        print(item)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        item?.image = photo
    }
}

