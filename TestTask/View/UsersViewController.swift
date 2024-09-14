import UIKit

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - ViewModel
    private let viewModel = UsersViewModel()
    
    // MARK: - UI Components
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Working with GET request"
        label.backgroundColor = .customYellow
        label.textAlignment = .center
        label.font = UIFont(name: "Nunito Sans 7pt", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell")
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()

    private let noUsersImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noUsers"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let noUsersLabel: UILabel = {
        let label = UILabel()
        label.text = "There are no users yet"
        label.textColor = .black
        label.font = UIFont.customFont(size: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let networkStateService = NetworkStateService()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
        setupNoUsersView()
        setupLayout()
        
        networkStateService.startMonitoring()
        
        bindViewModel()
        viewModel.fetchUsers()
    }
    
    // MARK: - TableView Setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        view.addSubview(tableView)
       
        refreshControl.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    // MARK: - NoUsers View Setup
    
    private func setupNoUsersView() {
        view.addSubview(noUsersImageView)
        view.addSubview(noUsersLabel)
    }
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        view.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            noUsersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noUsersImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            noUsersImageView.widthAnchor.constraint(equalToConstant: 200),
            noUsersImageView.heightAnchor.constraint(equalToConstant: 200),
            
            noUsersLabel.topAnchor.constraint(equalTo: noUsersImageView.bottomAnchor, constant: 20),
            noUsersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noUsersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noUsersLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        viewModel.didUpdateUsers = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func updateUI() {
        let hasUsers = viewModel.numberOfUsers() > 0
        tableView.isHidden = !hasUsers
        noUsersImageView.isHidden = hasUsers
        noUsersLabel.isHidden = hasUsers
        tableView.reloadData()
    }
    
    // MARK: - Refresh Control Action
    
    @objc private func refreshUsers() {
        viewModel.refreshUsers()
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        let user = viewModel.user(at: indexPath.row)
        cell.configure(with: user)
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > contentHeight - scrollViewHeight {
            viewModel.fetchUsers()
        }
    }
}
