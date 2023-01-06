//
//  HomeViewController.swift
//  RedditClient
//
//  Created by Armando Brito on 5/1/23.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Nested types

    struct Segue {
        static let toPermissions = "ToPermissions"
        static let toPermissionsNotAnimated = "ToPermissionsNotAnimated"
    }

    // MARK: - Properties

    private let persistenceService = PersistenceService()

    @IBOutlet weak var btnConfiguration: UIButton!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !persistenceService.isPermissionFlowComplete {
            self.performSegue(withIdentifier: Segue.toPermissionsNotAnimated, sender: self)
        }
    }

    // MARK: - Behavior

    @IBAction func onTouchConfiguration(_ sender: UIButton) {
        self.performSegue(withIdentifier: Segue.toPermissions, sender: self)
    }

}
