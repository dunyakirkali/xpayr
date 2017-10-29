//
//  EmptyView.swift
//  xpayr
//
//  Created by Dunya Kirkali on 10/29/17.
//  Copyright © 2017 Ahtung Ltd. Sti. All rights reserved.
//

import UIKit
import Lottie

class EmptyView: UIView {
    
    @IBOutlet weak var animationView: LOTAnimationView!
    
    override func awakeFromNib() {
        animationView = LOTAnimationView(name: "empty_box")
        animationView.loopAnimation = true
        animationView.play()
    }
}
