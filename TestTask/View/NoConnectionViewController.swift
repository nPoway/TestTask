import UIKit

class NoConnectionViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = NoConnectionViewModel()

    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noConnection"))
        imageView.tintColor = .systemRed
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "There is no internet connection"
        label.font = UIFont(name: "Nunito Sans 7pt", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tryAgainButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customYellow
        button.layer.cornerRadius = 25
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Try again", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()

        tryAgainButton.addTarget(self, action: #selector(tryAgainTapped), for: .touchUpInside)
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(tryAgainButton)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tryAgainButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            tryAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 50),
            tryAgainButton.widthAnchor.constraint(equalToConstant: 140)
        ])
    }

    // MARK: - Bindings
    private func setupBindings() {
        viewModel.onConnectionStatusChanged = { [weak self] isConnected in
            DispatchQueue.main.async {
                if isConnected {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - Actions
    @objc func tryAgainTapped() {
        if viewModel.retryConnection() {
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Still No Connection", message: "Please check your internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
