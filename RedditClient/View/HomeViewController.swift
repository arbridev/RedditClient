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

    let viewModel = HomeViewModel()

    @IBOutlet weak var btnConfiguration: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.updateUI = {
            self.update()
        }

        let searchPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: txtSearch)
        viewModel.searchPublisher = searchPublisher
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadPosts()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !viewModel.isPermissionFlowComplete {
            self.performSegue(withIdentifier: Segue.toPermissionsNotAnimated, sender: self)
        }
    }

    // MARK: - Behavior

    @IBAction func onTouchConfiguration(_ sender: UIButton) {
        self.performSegue(withIdentifier: Segue.toPermissions, sender: self)
    }

    func update() {
        print(viewModel.posts as AnyObject)
        print("updating ui")
    }

}
