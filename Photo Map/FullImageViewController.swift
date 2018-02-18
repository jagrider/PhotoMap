//
//  FullImageViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {
  
  var image: UIImage!
  @IBOutlet weak var fullImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fullImageView.image = image
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}
