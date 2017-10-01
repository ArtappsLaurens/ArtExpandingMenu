//
//  ViewController.swift
//  ArtExpandingMenu
//
//  Created by Laurens Biesheuvel on 28-09-17.
//  Copyright © 2017 Artapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var expandingMenu: ArtExpandingMenu!
    
    @IBAction func fullyExpandPressed(_ sender: Any) {
        expandingMenu.fullExpand()
        //expandingMenu.expandToRadius(radius: 500)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

