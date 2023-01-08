//
//  PermissionViewController.swift
//  RedditClient
//
//  Created by Armando Brito on 5/1/23.
//

import UIKit

class PermissionViewController: UIViewController {

    // MARK: - Properties

    let viewModel = PermissionViewModel(permissionKind: .camera)

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        lblTitle.text = viewModel.title
        lblDescription.text = viewModel.description
    }

    // MARK: - Behavior

    @IBAction func onTouchOk(_ sender: UIButton) {
        allowOrEnable()
    }
    
    @IBAction func onTouchCancel(_ sender: UIButton) {
        goNext()
    }

    func goNext() {
        guard let nextPermissionKind = viewModel.nextPermission() else {
            dismiss(animated: true)
            return
        }

        let vc = PermissionViewController.instantiate()
        vc.viewModel.permissionKind = nextPermissionKind
        navigationController?.pushViewController(vc, animated: true)
    }

    func allowOrEnable() {
        switch viewModel.permissionKind {
            case .camera:
                viewModel.allowCamera { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.goNext()
                    }
                }
            case .notifications:
                viewModel.enableNotifications { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.goNext()
                    }
                }
            case .location:
                viewModel.enableLocation { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.goNext()
                    }
                }
        }
    }
    
}
