import UIKit

class ErrorViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let errorImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "error"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "That email is already registered"
        label.font = UIFont.customFont(size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tryAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try again", for: .normal)
        button.titleLabel?.font = UIFont.customFont(size: 18)
        button.backgroundColor = .customYellow
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(errorImageView)
        view.addSubview(errorLabel)
        view.addSubview(tryAgainButton)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            errorImageView.widthAnchor.constraint(equalToConstant: 200),
            errorImageView.heightAnchor.constraint(equalToConstant: 200),
            
            errorLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 20),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tryAgainButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 30),
            tryAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 50),
            tryAgainButton.widthAnchor.constraint(equalToConstant: 140),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    // MARK: - Actions Setup
    
    private func setupActions() {
        tryAgainButton.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    private func tryAgainButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
