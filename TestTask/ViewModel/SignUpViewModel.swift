import Foundation

class SignUpViewModel {
    
    var name: String?
    var email: String?
    var phone: String?
    var selectedPositionID: Int?
    var positions: [Position] = []
    
    var didFetchPositions: (() -> Void)?
    
    private let registrationService = RegistrationService()
    
    // MARK: - Fetch Positions
    public func fetchPositions() {
        registrationService.fetchPositions { [weak self] result in
            switch result {
            case .success(let positions):
                self?.positions = positions
                DispatchQueue.main.async {
                    self?.didFetchPositions?()
                }
            case .failure(let error):
                print("Failed to fetch positions: \(error)")
            }
        }
    }
    
    // MARK: - Registration Request
    public func registerUser(photoData: Data, completion: @escaping (Result<RegistrationResponse, Error>) -> Void) {
        TokenManager.shared.fetchTokenIfNeeded { [weak self] result in
            switch result {
            case .success(let token):
                self?.performRegistration(photoData: photoData, token: token, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performRegistration(photoData: Data, token: String, completion: @escaping (Result<RegistrationResponse, Error>) -> Void) {
        guard let name = name, let email = email, let phone = phone, let positionID = selectedPositionID else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Missing data"])))
            return
        }
        
        let formFields: [String: String] = [
            "name": name,
            "email": email,
            "phone": phone,
            "position_id": "\(positionID)"
        ]
        
        registrationService.registerUser(with: token, photoData: photoData, formFields: formFields, completion: completion)
    }
    
    // MARK: - Validation
    public func validateFields() -> [ValidationError] {
        var errors = [ValidationError]()
        
        if name?.isEmpty == true {
            errors.append(.nameEmpty)
        }
        if email?.isEmpty == true {
            errors.append(.emailEmpty)
        } else if !isValidEmail(email!) {
            errors.append(.invalidEmail)
        }
        if phone?.isEmpty == true {
            errors.append(.phoneEmpty)
        } else if !isValidPhone(phone!) {
            errors.append(.invalidPhone)
        }
        if selectedPositionID == nil {
            errors.append(.positionNotSelected)
        }
        
        return errors
    }
    
    func getPositionID(for positionName: String?) -> Int? {
        return positions.first(where: { $0.name == positionName })?.id
    }

    // MARK: - Validation Helpers
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegEx = "^\\+38\\d{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegEx).evaluate(with: phone)
    }
}

enum ValidationError {
    case nameEmpty
    case emailEmpty
    case invalidEmail
    case phoneEmpty
    case invalidPhone
    case positionNotSelected
    case photoMissing
    
    var message: String {
        switch self {
        case .nameEmpty: return "Required field"
        case .emailEmpty: return "Required field"
        case .invalidEmail: return "Invalid email format"
        case .phoneEmpty: return "Required field"
        case .invalidPhone: return "Invalid phone number format"
        case .positionNotSelected: return "Position not selected"
        case .photoMissing: return "Photo is required"
        }
    }
}
