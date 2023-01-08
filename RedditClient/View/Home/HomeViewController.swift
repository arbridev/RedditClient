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

    private let tblRefreshControl = UIRefreshControl()

    @IBOutlet weak private var btnConfiguration: UIButton!
    @IBOutlet weak private var txtSearch: UITextField!
    @IBOutlet weak private var tblPosts: UITableView!

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtSearch.leftView = getSearchTextFieldLeftView()
        txtSearch.leftViewMode = .always
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        tblPosts.register(PostTableViewCell.nib, forCellReuseIdentifier: PostTableViewCell.identifier)
        tblPosts.dataSource = self
        tblPosts.refreshControl = tblRefreshControl
        tblRefreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)

        viewModel.updateUI = {
            self.update()
        }

        let searchPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: txtSearch)
        viewModel.searchPublisher = searchPublisher
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
        tblRefreshControl.endRefreshing()
    }

    private func getSearchTextFieldLeftView() -> UIImageView {
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .black
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return searchIcon
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            viewModel.loadPosts()
        }
    }

    @objc func pullToRefresh() {
        viewModel.loadPosts()
    }

}

// MARK: - Table view data source

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = viewModel.posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.config(post: post)
        return cell
    }

}
