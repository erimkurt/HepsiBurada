//
//  CarouselViewController.swift
//  Hepsiburada
//
//  Created by macbookair on 22.09.2018.
//  Copyright © 2018 Erim Kurt. All rights reserved.
//

import UIKit

class CarouselViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var index: Int = 0
    var image: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.displayImageFromURL(imagePath: image)
    }
}
