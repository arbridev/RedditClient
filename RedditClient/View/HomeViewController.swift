//
//  HomeViewController.swift
//  RedditClient
//
//  Created by Armando Brito on 5/1/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    struct Segue {
        static let toPermissions = "ToPermissions"
    }

    @IBOutlet weak var btnConfiguration: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onTouchConfiguration(_ sender: UIButton) {
        self.performSegue(withIdentifier: Segue.toPermissions, sender: self)
    }

}
