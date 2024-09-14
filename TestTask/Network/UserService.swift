import Foundation

class UserService {
    
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1/users"
    
    func fetchUsers(page: Int, usersPerPage: Int, completion: @escaping (Result<UsersResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?page=\(page)&count=\(usersPerPage)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received."])
                completion(.failure(error))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(UsersResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
