import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private var token: String?
    
    func fetchTokenIfNeeded(completion: @escaping (Result<String, Error>) -> Void) {
        if let token = token {
            completion(.success(token))
        } else {
            refreshToken(completion: completion)
        }
    }
    
    func refreshToken(completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/token")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                self?.token = decodedResponse.token
                completion(.success(decodedResponse.token))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

struct TokenResponse: Decodable {
    let success: Bool
    let token: String
}
