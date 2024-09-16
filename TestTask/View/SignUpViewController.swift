import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private let viewModel = SignUpViewModel()
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Working with POST request"
        label.backgroundColor = .customYellow
        label.textAlignment = .center
        label.font = UIFont.customFont(size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField = SignUpViewController.createTextField(placeholder: "Your name")
    private let emailTextField = SignUpViewController.createTextField(placeholder: "Email", autocapitalization: .none)
    private let phoneTextField = SignUpViewController.createTextField(placeholder: "Phone")
    
    private let phoneFormatLabel: UILabel = {
        let label = UILabel()
        label.text = "+38 (XXX) XXX - XX - XX"
        label.font = UIFont.customFont(size: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectPositionLabel = SignUpViewController.createLabel(text: "Select your position", fontSize: 18)
    
    private let positionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let uploadContainerView: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 5
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray4.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let uploadLabel = SignUpViewController.createLabel(text: "Upload your photo", fontSize: 18, color: .systemGray)
    
    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Photo is required"
        label.font = UIFont.customFont(size: 14)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.customFont(size: 18)
        button.backgroundColor = .customYellow
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectedPosition: String? {
        didSet {
            updateRadioButtons()
        }
    }
    
    private var selectedPhoto: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupUI()
        bindViewModel()
        viewModel.fetchPositions()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
    }
    
    // MARK: - Setup Methods
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        contentView.addSubview(headerLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(phoneFormatLabel)
        contentView.addSubview(selectPositionLabel)
        contentView.addSubview(positionStackView)
        contentView.addSubview(uploadContainerView)
        contentView.addSubview(errorLabel)
        contentView.addSubview(signUpButton)
        
        uploadContainerView.addSubview(uploadLabel)
        uploadContainerView.addSubview(uploadButton)
        
        setupLayout()
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 56),
            
            nameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 56),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 56),
            
            phoneTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            phoneTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 56),
            
            phoneFormatLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 5),
            phoneFormatLabel.leadingAnchor.constraint(equalTo: phoneTextField.leadingAnchor, constant: 15),
            phoneFormatLabel.trailingAnchor.constraint(equalTo: phoneTextField.trailingAnchor),
            
            selectPositionLabel.topAnchor.constraint(equalTo: phoneFormatLabel.bottomAnchor, constant: 35),
            selectPositionLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            
            positionStackView.topAnchor.constraint(equalTo: selectPositionLabel.bottomAnchor, constant: 30),
            positionStackView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            positionStackView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            uploadContainerView.topAnchor.constraint(equalTo: positionStackView.bottomAnchor, constant: 35),
            uploadContainerView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            uploadContainerView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            uploadContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            uploadLabel.leadingAnchor.constraint(equalTo: uploadContainerView.leadingAnchor, constant: 15),
            uploadLabel.centerYAnchor.constraint(equalTo: uploadContainerView.centerYAnchor),
            
            uploadButton.trailingAnchor.constraint(equalTo: uploadContainerView.trailingAnchor, constant: -25),
            uploadButton.centerYAnchor.constraint(equalTo: uploadContainerView.centerYAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: uploadContainerView.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: uploadContainerView.leadingAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: uploadContainerView.bottomAnchor, constant: 40),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalToConstant: 140),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        viewModel.didFetchPositions = { [weak self] in
            self?.setupRadioButtons()
        }
    }
    
    // MARK: - Form Validation
    
    private func validateForm() -> [ValidationError] {
        viewModel.name = nameTextField.text
        viewModel.email = emailTextField.text
        viewModel.phone = phoneTextField.text
        viewModel.selectedPositionID = viewModel.getPositionID(for: selectedPosition)
        
        var errors = viewModel.validateFields()
        handleValidationErrors(errors)
        
        if selectedPhoto == nil {
            errors.append(.photoMissing)
            uploadContainerView.layer.borderColor = UIColor.red.cgColor
            uploadContainerView.layer.borderWidth = 1.0
            errorLabel.isHidden = false
        } else {
            uploadContainerView.layer.borderColor = UIColor.systemGray4.cgColor
            uploadContainerView.layer.borderWidth = 1.0
            errorLabel.isHidden = true
        }
        
        return errors
    }
    
    // MARK: - Radio Buttons Setup
    
    private func setupRadioButtons() {
        for position in viewModel.positions {
            addRadioButton(title: position.name, isSelected: selectedPosition == position.name)
        }
    }
    
    private func addRadioButton(title: String, isSelected: Bool = false) {
        var config = UIButton.Configuration.plain()
        config.title = title
        
        let image = UIImage(named: isSelected ? "selectedRadio" : "radio")?.resized(to: CGSize(width: 14, height: 14))
        config.image = image
        config.imagePadding = 25
        config.imagePlacement = .leading
        
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.customFont(size: 16),
            .foregroundColor: UIColor.black
        ]))
        
        let button = UIButton(configuration: config)
        button.tintColor = .darkGray
        button.contentHorizontalAlignment = .leading
        
        button.addTarget(self, action: #selector(selectPosition), for: .touchUpInside)
        positionStackView.addArrangedSubview(button)
    }
    
    @objc private func selectPosition(sender: UIButton) {
        guard let title = sender.configuration?.title else { return }
        selectedPosition = title
        updateRadioButtons()
    }
    
    private func updateRadioButtons() {
        for case let button as UIButton in positionStackView.arrangedSubviews {
            let isSelected = button.configuration?.title == selectedPosition
            let imageName = isSelected ? "selectedRadio" : "radio"
            let image = UIImage(named: imageName)?.resized(to: CGSize(width: 14, height: 14))
            button.configuration?.image = image
        }
    }
    
    // MARK: - Upload Photo
    
    @objc
    private func uploadButtonTapped() {
        let alert = UIAlertController(title: "Choose how you want to add a photo", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera)
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Present Image Picker
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true, completion: nil)
        } else {
            let sourceName = sourceType == .camera ? "Camera" : "Photo Library"
            print("\(sourceName) not available")
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedPhoto = image
            uploadLabel.text = "Photo selected"
            uploadLabel.textColor = .black
            updatePhotoSelectionUI()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Update Photo Selection UI
    
    private func updatePhotoSelectionUI() {
        if selectedPhoto == nil {
            uploadContainerView.layer.borderColor = UIColor.red.cgColor
            uploadContainerView.layer.borderWidth = 1.0
            errorLabel.isHidden = false
        } else {
            uploadContainerView.layer.borderColor = UIColor.systemGray4.cgColor
            uploadContainerView.layer.borderWidth = 1.0
            errorLabel.isHidden = true
        }
    }
    
    
    // MARK: - Registration Request Handling
    
    @objc private func signUpButtonTapped() {
        let errors = validateForm()
        
        guard errors.isEmpty, selectedPhoto != nil else {
            return
        }
        
        sendRegistrationRequest()
    }
    
    private func sendRegistrationRequest() {
        guard let photoData = selectedPhoto?.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        viewModel.registerUser(photoData: photoData) { [weak self] result in
            DispatchQueue.main.async {
                self?.handleRegistrationResult(result)
            }
        }
    }
    
    private func handleRegistrationResult(_ result: Result<RegistrationResponse, Error>) {
        switch result {
        case .success(let response):
            if response.success {
                showSuccessScreen()
            } else if response.message == "User with this phone or email already exist" {
                showErrorScreen()
            } else {
                print("Registration error: \(response.message ?? "Unknown error")")
            }
        case .failure(let error):
            print("Registration error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Error Handling
    
    private func handleValidationErrors(_ errors: [ValidationError]) {
        resetTextFieldBorders()
        
        for error in errors {
            switch error {
            case .nameEmpty:
                setTextFieldInvalid(textField: nameTextField, message: error.message)
            case .emailEmpty, .invalidEmail:
                setTextFieldInvalid(textField: emailTextField, message: error.message)
            case .phoneEmpty, .invalidPhone:
                setTextFieldInvalid(textField: phoneTextField, message: error.message)
            case .positionNotSelected:
                setPositionInvalid(message: error.message)
            case .photoMissing:
                handlePhotoValidationError(message: error.message)
            }
        }
    }
    
    private func handlePhotoValidationError(message: String) {
        uploadContainerView.layer.borderColor = UIColor.red.cgColor
        uploadContainerView.layer.borderWidth = 1.0
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    // MARK: - Helper Methods
    
    private static func createTextField(placeholder: String, autocapitalization: UITextAutocapitalizationType = .sentences) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = autocapitalization
        let placeholderFont = UIFont.customFont(size: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: placeholderFont,
            .foregroundColor: UIColor.systemGray
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        textField.setLeftPaddingPoints(10)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private static func createLabel(text: String, fontSize: CGFloat, color: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.customFont(size: fontSize)
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func resetTextFieldBorders() {
        [nameTextField, emailTextField, phoneTextField].forEach { textField in
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0.0
        }
        
        for subview in contentView.subviews where subview is UILabel && subview.tag == 999 {
            subview.removeFromSuperview()
        }
    }
    
    private func setPositionInvalid(message: String) {
        let errorLabel = UILabel()
        errorLabel.text = message
        errorLabel.textColor = .red
        errorLabel.font = UIFont.customFont(size: 12)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.tag = 999
        contentView.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: selectPositionLabel.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: selectPositionLabel.leadingAnchor)
        ])
    }
    
    private func setTextFieldInvalid(textField: UITextField, message: String) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 4
        
        if textField == phoneTextField {
            phoneFormatLabel.isHidden = true
        }
        
        let errorLabel = UILabel()
        errorLabel.text = message
        errorLabel.textColor = .red
        errorLabel.font = UIFont.customFont(size: 12)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.tag = 999
        contentView.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor)
        ])
    }
    
    private func showSuccessScreen() {
        let successVC = SuccessViewController()
        successVC.modalPresentationStyle = .fullScreen
        present(successVC, animated: true, completion: nil)
    }
    
    private func showErrorScreen() {
        let errorVC = ErrorViewController()
        errorVC.modalPresentationStyle = .fullScreen
        present(errorVC, animated: true, completion: nil)
    }
    //    MARK: - TextField Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
