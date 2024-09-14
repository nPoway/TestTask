import Foundation

class UsersViewModel {

    private var users: [User] = []
    public var didUpdateUsers: (() -> Void)?
    
    private var currentPage = 1
    private let usersPerPage = 6
    private var isLoading = false
    private var canLoadMore = true
    
    private let userService = UserService()

   public func refreshUsers() {
        users = []
        currentPage = 1
        canLoadMore = true
        fetchUsers()
    }

   public func fetchUsers() {
        guard !isLoading && canLoadMore else { return }
        isLoading = true

        userService.fetchUsers(page: currentPage, usersPerPage: usersPerPage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.users.append(contentsOf: response.users)
                self?.currentPage += 1
                self?.canLoadMore = response.users.count == self?.usersPerPage
                self?.didUpdateUsers?()
            case .failure(let error):
                print("Error fetching users: \(error.localizedDescription)")
            }
            self?.isLoading = false
        }
    }

   public func numberOfUsers() -> Int {
        return users.count
    }

   public func user(at index: Int) -> User {
        return users[index]
    }
}
