import UIKit

struct RegistrationRequest: Codable {
    let login: String
    let email: String
    let name: String
    let password1: String
    let password2: String
}

struct UserInsert: Codable {
    let username: String
    let email: String
    let name: String
    let password: String
}

struct ProfileInsert: Codable {
    let email: String
    let name: String
    let password: String
}

import UIKit
import Supabase


final class RegistrationViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Регистрация нового аккаунта"
        lbl.font = .boldSystemFont(ofSize: 32)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Email"
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        return lbl
    }()
    
    private let emailInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите email"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let loginLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Login"
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        return lbl
    }()
    
    private let loginInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите login"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Имя"
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        return lbl
    }()
    
    private let nameInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите имя"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Пароль"
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        return lbl
    }()
    
    private let passwordInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите пароль"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let registerBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Регистрация", for: .normal)
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 6
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        return btn
    }()
    
    private let backToLoginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Вернуться к авторизации", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        return btn
    }()
    
    private let errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemRed
        lbl.font = .systemFont(ofSize: 14)
        lbl.numberOfLines = 0
        lbl.isHidden = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        
        registerBtn.addTarget(self, action: #selector(registerClick), for: .touchUpInside)
        backToLoginBtn.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
    }
    
    // MARK: - Layout
    private func setupUI() {
        [titleLabel, emailLabel, emailInput,
         loginLabel, loginInput,
         nameLabel, nameInput,
         passwordLabel, passwordInput,
         errorLabel, registerBtn, backToLoginBtn].forEach { view.addSubview($0) }

        let sideMargin: CGFloat = 20

        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),

            // Email
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            emailLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),

            emailInput.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 6),
            emailInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            emailInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),
            emailInput.heightAnchor.constraint(equalToConstant: 44),

            // Login
            loginLabel.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 20),
            loginLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            loginLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),

            loginInput.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 6),
            loginInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            loginInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),
            loginInput.heightAnchor.constraint(equalToConstant: 44),

            // Name
            nameLabel.topAnchor.constraint(equalTo: loginInput.bottomAnchor, constant: 20),
            nameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            nameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),

            nameInput.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            nameInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            nameInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),
            nameInput.heightAnchor.constraint(equalToConstant: 44),

            // Password
            passwordLabel.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: 20),
            passwordLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            passwordLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),

            passwordInput.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 6),
            passwordInput.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            passwordInput.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),
            passwordInput.heightAnchor.constraint(equalToConstant: 44),

            // Ошибки
            errorLabel.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 8),
            errorLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            errorLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),

            // Регистрация
            registerBtn.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            registerBtn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            registerBtn.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),
            registerBtn.heightAnchor.constraint(equalToConstant: 50),

            // Вернуться к авторизации
            backToLoginBtn.topAnchor.constraint(equalTo: registerBtn.bottomAnchor, constant: 15),
            backToLoginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func registerClick() {
        // Сброс ошибок
        [emailInput, loginInput, nameInput, passwordInput].forEach { field in
            field.layer.borderWidth = 0
            field.layer.borderColor = UIColor.clear.cgColor
            field.layer.cornerRadius = 6
            field.layer.masksToBounds = true
        }
        errorLabel.isHidden = true
        
        guard let email = emailInput.text, !email.isEmpty,
              let login = loginInput.text, !login.isEmpty,
              let name = nameInput.text, !name.isEmpty,
              let password = passwordInput.text, !password.isEmpty else {
            errorLabel.text = "Пожалуйста, заполните все поля"
            errorLabel.isHidden = false
            return
        }
        
        let supabase = SupabaseService.shared.client
        
        Task {
            do {
                let response = try await supabase.auth.signUp(
                    email: email,
                    password: password,
                    data: ["name": .string(name), "login": .string(login)]
                )
                print("Регистрация успешна! ID:", response.user.id)
                
                let profile = ProfileInsert(email: email, name: name, password: password)
                try await supabase.from("users_swift").insert(profile).execute()
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true) // закрыть экран регистрации
                }
            } catch {
                print("Ошибка регистрации:", error)
                DispatchQueue.main.async {
                    self.errorLabel.text = "Ошибка регистрации: \(error.localizedDescription)"
                    self.errorLabel.isHidden = false
                    self.emailInput.layer.borderWidth = 1
                    self.emailInput.layer.borderColor = UIColor.systemRed.cgColor
                }
            }
        }
    }
    
    @objc private func backToLogin() {
        self.dismiss(animated: true)
    }
}
