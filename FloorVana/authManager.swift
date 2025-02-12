import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    // Sign Up
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Update User Profile
    func updateUserProfile(username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "No user logged in."])))
            return
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = username
        changeRequest.commitChanges { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Check if user is logged in
    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    // Get current user
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    // Log Out
    func logOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    func getCurrentUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
}
