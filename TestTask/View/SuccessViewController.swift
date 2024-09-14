import UIKit

class SuccessViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let successImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "success"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "User successfully registered"
        label.font = UIFont.customFont(size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gotItButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Got it", for: .normal)
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
        view.addSubview(successImageView)
        view.addSubview(successLabel)
        view.addSubview(gotItButton)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            successImageView.widthAnchor.constraint(equalToConstant: 200),
            successImageView.heightAnchor.constraint(equalToConstant: 200),
            
            successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            gotItButton.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 30),
            gotItButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gotItButton.heightAnchor.constraint(equalToConstant: 50),
            gotItButton.widthAnchor.constraint(equalToConstant: 140),
           
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    // MARK: - Actions Setup
    
    private func setupActions() {
        gotItButton.addTarget(self, action: #selector(gotItButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    private func gotItButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
