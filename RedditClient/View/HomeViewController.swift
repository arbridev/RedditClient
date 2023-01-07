//
//  HomeViewController.swift
//  RedditClient
//
//  Created by Armando Brito on 5/1/23.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: Nested types

    struct Segue {
        static let toPermissions = "ToPermissions"
        static let toPermissionsNotAnimated = "ToPermissionsNotAnimated"
    }

    // MARK: Properties

    let viewModel = HomeViewModel()

    @IBOutlet weak private var btnConfiguration: UIButton!
    @IBOutlet weak private var txtSearch: UITextField!
    @IBOutlet weak private var tblPosts: UITableView!

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblPosts.dataSource = self
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

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

    // MARK: Behavior

    @IBAction func onTouchConfiguration(_ sender: UIButton) {
        self.performSegue(withIdentifier: Segue.toPermissions, sender: self)
    }

    func update() {
        print(viewModel.posts as AnyObject)
        print("updating ui")
        tblPosts.reloadData()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            viewModel.loadPosts()
        }
    }

}

// MARK: - Table view data source

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = viewModel.posts[indexPath.row]

        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }

        var content = cell?.defaultContentConfiguration()
        content?.text = post.data.title
        content?.secondaryText = post.data.url

        cell?.contentConfiguration = content

        return cell!
    }

}
