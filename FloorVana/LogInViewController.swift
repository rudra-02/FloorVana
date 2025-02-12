import UIKit
import FirebaseAuth // Import Firebase Authentication

class LogInViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var tempProjectData: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadTempProjectData()
    }
    
    private func setupUI() {
        // Set up gesture recognizer for dismissing the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Style the login button
        loginButton.layer.cornerRadius = 8
        loginButton.clipsToBounds = true
    }
    
    private func loadTempProjectData() {
        // Retrieve tempProjectData from UserDefaults if it exists
        if let savedProjectData = UserDefaults.standard.dictionary(forKey: "tempProjectData") {
            tempProjectData = savedProjectData
            print("Loaded saved project data: \(tempProjectData!)")
        } else {
            print("No project data found in UserDefaults")
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let emailText = email.text, !emailText.isEmpty,
              let passwordText = password.text, !passwordText.isEmpty else {
            showAlert(title: "Missing Information", message: "Please enter both email and password.")
            return
        }
        
        // Use Firebase Authentication to sign in
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                // Show error if login fails
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }
            
            // Successfully logged in
            print("User logged in: \(authResult?.user.email ?? "Unknown")")
            self.handlePostLoginActions()
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "SignUpSegue", sender: nil)
    }
    
    private func handlePostLoginActions() {
        // Handle project data if it exists
        if let projectData = tempProjectData {
            GeneratedScreenViewController.sharedGen.saveProjectFromTempData(projectData)
            print("Project data saved successfully after login")
            
            // Clear temp project data
            tempProjectData = nil
            UserDefaults.standard.removeObject(forKey: "tempProjectData")
        } else {
            print("No project data found to save after login.")
        }
        
        // Navigate to TabBarController
        navigateToTabBarController()
    }
    
    private func navigateToTabBarController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.selectedIndex = 2 // Navigate to the desired tab
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
