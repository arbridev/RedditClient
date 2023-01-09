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

    @IBOutlet weak private var imgPermissionSubject: UIImageView!
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblDescription: UILabel!
    @IBOutlet weak private var btnOk: UIButton!
    @IBOutlet weak private var btnCancel: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        imgPermissionSubject.image = getPermissionSubjectImage()
        lblTitle.text = viewModel.title
        lblDescription.text = viewModel.description
        setupAllowOrEnableButton(btnOk)
    }

    // MARK: - Behavior

    @IBAction private func onTouchOk(_ sender: UIButton) {
        allowOrEnable()
    }
    
    @IBAction private func onTouchCancel(_ sender: UIButton) {
        goNext()
    }

    private func goNext() {
        guard let nextPermissionKind = viewModel.nextPermission() else {
            dismiss(animated: true)
            return
        }

        let vc = PermissionViewController.instantiate()
        vc.viewModel.permissionKind = nextPermissionKind
        navigationController?.pushViewController(vc, animated: true)
    }

    private func allowOrEnable() {
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

    private func getPermissionSubjectImage() -> UIImage {
        var image: UIImage!
        switch viewModel.permissionKind {
            case .camera:
                image = UIImage.Permissions.camera
            case .notifications:
                image = UIImage.Permissions.bell
            case .location:
                image = UIImage.Permissions.map
        }
        return image
    }

    private func setupAllowOrEnableButton(_ button: UIButton) {
        let layer = CAGradientLayer()
        layer.frame = button.bounds
        layer.colors = [
            UIColor.Defined.AccentGradient.pink.cgColor,
            UIColor.Defined.AccentGradient.orange.cgColor
        ]
        layer.cornerRadius = button.bounds.height / 2
        button.layer.insertSublayer(layer, at: 0)
        button.setTitleColor(.white, for: .normal)
    }
    
}
