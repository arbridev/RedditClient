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

    private var noResultsView: UIView?

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
        tblPosts.separatorStyle = .none
        tblPosts.showsVerticalScrollIndicator = false
        tblPosts.refreshControl = tblRefreshControl
        tblPosts.keyboardDismissMode = .onDrag
        tblRefreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)

        setNoResultsView()

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
        showNoResults(viewModel.posts.isEmpty)
    }

    private func getSearchTextFieldLeftView() -> UIImageView {
        let searchIcon = UIImageView(image: UIImage.Icon.magnifyingGlass)
        searchIcon.tintColor = .lightGray
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return searchIcon
    }

    private func setNoResultsView() {
        noResultsView = NoResultsViewController(nibName: NoResultsViewController.identifier, bundle: nil).view
        guard let noResultsView else {
            return
        }
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noResultsView)

        noResultsView.topAnchor.constraint(equalTo: tblPosts.topAnchor).isActive = true
        noResultsView.bottomAnchor.constraint(equalTo: tblPosts.bottomAnchor).isActive = true
        noResultsView.leadingAnchor.constraint(equalTo: tblPosts.leadingAnchor).isActive = true
        noResultsView.trailingAnchor.constraint(equalTo: tblPosts.trailingAnchor).isActive = true

        showNoResults(false)
    }

    private func showNoResults(_ show: Bool) {
        noResultsView?.isHidden = !show
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
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.identifier,
            for: indexPath
        ) as! PostTableViewCell
        cell.config(post: post)
        return cell
    }

}
