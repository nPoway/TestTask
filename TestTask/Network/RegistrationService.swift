import Foundation

class RegistrationService {
    
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"
    
    public func fetchPositions(completion: @escaping (Result<[Position], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/positions") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PositionResponse.self, from: data)
                completion(.success(decodedResponse.positions))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func registerUser(with token: String, photoData: Data, formFields: [String: String], completion: @escaping (Result<RegistrationResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Token")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createMultipartBody(formFields: formFields, photoData: photoData, boundary: boundary)
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(RegistrationResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func createMultipartBody(formFields: [String: String], photoData: Data, boundary: String) -> Data {
        var body = Data()

        for (key, value) in formFields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(photoData)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        return body
    }
}
