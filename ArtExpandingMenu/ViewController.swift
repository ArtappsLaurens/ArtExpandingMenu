//
//  ViewController.swift
//  ArtExpandingMenu
//
//  Created by Laurens Biesheuvel on 28-09-17.
//  Copyright © 2017 Artapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var menu: ArtExpandingMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.options = [("plus", "First option"), ("plus", "Second option"), ("plus", "Third option")]
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func optionPressed(_ sender: Any) {
        print("option pressed: \(menu.lastSelectedOption!)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

