import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var deleteAccountLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfile()
    }
    
    func updateUserProfile(username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    
    private func setupProfile() {
        // Check if the user is logged in
        if AuthManager.shared.isLoggedIn() {
            if let email = AuthManager.shared.getCurrentUserEmail() {
                usernameLabel.text = email.components(separatedBy: "@").first ?? "User"
                emailLabel.text = email
                phoneLabel.text = "9876543210" // Placeholder, replace with actual data if available
                
                logoutButton.isHidden = false
            }
        } else {
            // Show alert and redirect to login if not logged in
            let alert = UIAlertController(
                title: "Not Logged In",
                message: "Log in to view your profile",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.redirectToLogin()
            }))
            present(alert, animated: true)
            
            logoutButton.isHidden = true
        }
    }
    
    private func redirectToLogin() {
        let loginStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    private func redirectToHome() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.selectedIndex = 0 // Assuming Home tab is at index 0
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        // Log out the user using AuthManager
        AuthManager.shared.logOut { result in
            switch result {
            case .success:
                let alert = UIAlertController(
                    title: "Logged Out",
                    message: "You have been logged out successfully.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.redirectToHome()
                }))
                self.present(alert, animated: true)
            case .failure(let error):
                let alert = UIAlertController(
                    title: "Logout Failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
