import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let username = NameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = PasswordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        if password.count < 6 {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters long.")
            return
        }
        
        // Use AuthManager to handle sign-up
        AuthManager.shared.signUp(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                // Add username to user's profile (if needed)
                AuthManager.shared.updateUserProfile(username: username) { updateResult in
                    switch updateResult {
                    case .success:
                        self.showAlert(title: "Success", message: "Sign-up successful!")
                    case .failure(let error):
                        self.showAlert(title: "Profile Update Failed", message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if title == "Success" {
                self.redirectToLogin()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func redirectToLogin() {
        let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {
            self.present(loginVC, animated: true, completion: nil)
        }
    }
}
