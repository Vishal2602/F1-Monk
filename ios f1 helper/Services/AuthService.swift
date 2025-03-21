import Foundation
import Combine

class AuthService {
    static let shared = AuthService()
    
    private var user: User?
    private let userKey = "currentUser"
    
    var isLoggedIn: Bool {
        return user != nil
    }
    
    private init() {
        loadUser()
    }
    
    func signIn(email: String, password: String) -> Bool {
        // In a real app, this would verify credentials against a backend
        // For demo purposes, we'll consider .edu emails valid
        guard email.hasSuffix(".edu") else { return false }
        
        // Create a dummy user profile for now
        let userId = UUID().uuidString
        let name = email.components(separatedBy: "@").first ?? "Student"
        
        let today = Date()
        let calendar = Calendar.current
        let programStart = calendar.date(byAdding: .month, value: -6, to: today) ?? today
        let programEnd = calendar.date(byAdding: .year, value: 2, to: today) ?? today
        let i20Expiry = calendar.date(byAdding: .month, value: 1, to: programEnd) ?? programEnd
        
        user = User(
            id: userId,
            name: name,
            email: email,
            university: "University",
            major: "Computer Science",
            programLevel: ProgramLevel.masters.rawValue,
            programStartDate: programStart,
            programEndDate: programEnd,
            i20ExpiryDate: i20Expiry,
            hasOptApplied: false,
            isSevisActive: true,
            visaExpiryDate: calendar.date(byAdding: .year, value: 5, to: today)
        )
        
        saveUser()
        return true
    }
    
    func signUp(name: String, email: String, password: String) -> Bool {
        // Validate college email
        guard email.hasSuffix(".edu") else { return false }
        
        // In a real app, this would create a user in the backend
        let userId = UUID().uuidString
        
        let today = Date()
        let calendar = Calendar.current
        let programStart = today
        let programEnd = calendar.date(byAdding: .year, value: 2, to: today) ?? today
        let i20Expiry = calendar.date(byAdding: .month, value: 1, to: programEnd) ?? programEnd
        
        user = User(
            id: userId,
            name: name,
            email: email,
            university: "",
            major: "",
            programLevel: ProgramLevel.masters.rawValue,
            programStartDate: programStart,
            programEndDate: programEnd,
            i20ExpiryDate: i20Expiry,
            hasOptApplied: false,
            isSevisActive: true,
            visaExpiryDate: nil
        )
        
        saveUser()
        return true
    }
    
    func updateProfile(_ updatedUser: User) {
        user = updatedUser
        saveUser()
    }
    
    func signOut() {
        user = nil
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    func getCurrentUser() -> User? {
        return user
    }
    
    private func saveUser() {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    private func loadUser() {
        if let userData = UserDefaults.standard.data(forKey: userKey),
           let decodedUser = try? JSONDecoder().decode(User.self, from: userData) {
            user = decodedUser
        }
    }
} 