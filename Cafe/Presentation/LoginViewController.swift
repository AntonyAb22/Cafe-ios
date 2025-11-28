import UIKit
import Supabase

struct LoginRequest: Codable {
    let id: Int
    let username: String
    let password: String
}

struct User: Decodable {
    let id: Int
    let username: String
    let password: String
}

import Foundation
import Supabase

final class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://ahasxpolxjysjrcvulgw.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFoYXN4cG9seGp5c2pyY3Z1bGd3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIzNTMzMjUsImV4cCI6MjA3NzkyOTMyNX0.hGakP8HMHj3BgfS-lpM0kz1xZ8QV26tD4KjWSYo4gfI"
        )
    }
}

final class LoginViewController: UIViewController {
    
    // MARK: UI Elements
    private let cafeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "cafe") // твоё лого
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = false
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let loginLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Логин / Email"
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        return lbl
    }()
    
    private let loginInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите email"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Пароль"
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        return lbl
    }()
    
    private let passInput: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите пароль"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // кнопка-глаз
    private let passwordToggleButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye"), for: .normal)
        btn.tintColor = .gray
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemRed
        lbl.font = .systemFont(ofSize: 14)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.text = "Неправильный логин/email или пароль"
        lbl.isHidden = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let forgotPasswordLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Забыли пароль?"
        lbl.textColor = .systemBlue
        lbl.font = .systemFont(ofSize: 14)
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Войти в систему", for: .normal)
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let registerBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Регистрация", for: .normal)
        btn.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    // MARK: Layout
    private func setupUI() {
        view.addSubview(cafeImageView)
        view.addSubview(loginLabel)
        view.addSubview(loginInput)
        view.addSubview(passLabel)
        view.addSubview(passInput)
        view.addSubview(errorLabel)
        view.addSubview(forgotPasswordLabel)
        view.addSubview(loginBtn)
        view.addSubview(registerBtn)

        NSLayoutConstraint.activate([
            // Лого
            cafeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cafeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cafeImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.6),
            cafeImageView.heightAnchor.constraint(equalTo: cafeImageView.widthAnchor), // квадратное

            // Блок формы ниже
            loginLabel.topAnchor.constraint(equalTo: cafeImageView.bottomAnchor, constant: 40),
            loginLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            loginInput.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            loginInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            loginInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            loginInput.heightAnchor.constraint(equalToConstant: 44),

            passLabel.topAnchor.constraint(equalTo: loginInput.bottomAnchor, constant: 25),
            passLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            passInput.topAnchor.constraint(equalTo: passLabel.bottomAnchor, constant: 8),
            passInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            passInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            passInput.heightAnchor.constraint(equalToConstant: 44),
            
            forgotPasswordLabel.topAnchor.constraint(equalTo: passInput.bottomAnchor, constant: 8),
            forgotPasswordLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),

            errorLabel.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 4),
            errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            

            loginBtn.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 40),
            loginBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            loginBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),

            registerBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 20),
            registerBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            registerBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            registerBtn.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Add Eye Button to Password Field
    private func setupPasswordToggle() {
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        passInput.rightView = passwordToggleButton
        passInput.rightViewMode = .always
        
        // Изначально пароль скрыт → ставим "eye.slash"
        passwordToggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    
    @objc private func togglePasswordVisibility() {
        passInput.isSecureTextEntry.toggle()
        let icon = passInput.isSecureTextEntry ? "eye.slash" : "eye"
        passwordToggleButton.setImage(UIImage(systemName: icon), for: .normal)
    }
    
    // MARK: Login Action
    @objc private func loginClick() {
        // Сбрасываем ошибки
        loginInput.layer.borderWidth = 0
        loginInput.layer.borderColor = UIColor.clear.cgColor
        passInput.layer.borderWidth = 0
        passInput.layer.borderColor = UIColor.clear.cgColor
        errorLabel.isHidden = true
        
        guard let username = loginInput.text, !username.isEmpty,
              let password = passInput.text, !password.isEmpty else {
            print("Поля пустые")
            return
        }
        
        let supabase = SupabaseService.shared.client
        
        Task {
            do {
                let response = try await supabase.auth.signUp(
                    email: username,
                    password: password
                )
                
                print("Login successful! ID:", response.user.id)
                
                //                openHomeScreen()
                
            } catch {
                print("Ошибка при логине:", error.localizedDescription)
                
                // Показываем красный бордер
                loginInput.layer.borderWidth = 1
                loginInput.layer.borderColor = UIColor.systemRed.cgColor
                loginInput.layer.cornerRadius = 6
                loginInput.layer.masksToBounds = true

                passInput.layer.borderWidth = 1
                passInput.layer.borderColor = UIColor.systemRed.cgColor
                passInput.layer.cornerRadius = 6
                passInput.layer.masksToBounds = true
                
                // Показываем текст ошибки
                errorLabel.isHidden = false
            }
        }
    }
    
    @objc private func openRegisterScreen() {
        let registerVC = RegistrationViewController()
        registerVC.modalPresentationStyle = .fullScreen
        self.present(registerVC, animated: true)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupPasswordToggle()
        
        loginBtn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(openRegisterScreen), for: .touchUpInside)
    }
}
