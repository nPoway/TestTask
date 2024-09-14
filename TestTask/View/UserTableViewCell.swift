import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(size: 18)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(size: 14)
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(size: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(size: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Configuration
    
    func configure(with user: User) {
        nameLabel.text = user.name
        positionLabel.text = user.position
        emailLabel.text = user.email
        phoneLabel.text = formatPhoneNumber(user.phone)
        
        if let url = URL(string: user.photo) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.userImageView.image = image
                    }
                }
            }
            task.resume()
        }
        
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(positionLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(userImageView)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            userImageView.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            
            positionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            positionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            positionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            emailLabel.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            phoneLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            phoneLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Helper Methods
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        let cleanPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+## (###) ### ## ##"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
