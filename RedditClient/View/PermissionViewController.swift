//
//  PermissionViewController.swift
//  RedditClient
//
//  Created by Armando Brito on 5/1/23.
//

import UIKit

class PermissionViewController: UIViewController {

    var permissionKind: PermissionKind = .camera

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        switch permissionKind {
            case .camera:
                lblTitle.text = "Camera"
            case .notifications:
                lblTitle.text = "Notifications"
            case .location:
                lblTitle.text = "Location"
        }

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func onTouchOk(_ sender: UIButton) {
        navigate()
    }
    
    @IBAction func onTouchCancel(_ sender: UIButton) {
        navigate()
    }

    func navigate() {
        let navFlow = Constant.permissionNavigationFlow
        var nextPermissionKind: PermissionKind!
        if let navFlowIndex = navFlow.firstIndex(of: permissionKind),
            navFlowIndex + 1 < navFlow.count {
            nextPermissionKind = navFlow[navFlowIndex + 1]
        } else {
            dismiss(animated: true)
            return
        }

        let vc = PermissionViewController.instantiate()
        vc.permissionKind = nextPermissionKind
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
