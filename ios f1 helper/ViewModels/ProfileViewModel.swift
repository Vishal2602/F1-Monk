import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn = false
    @Published var showOnboarding = false
    
    // Authentication fields
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var errorMessage = ""
    
    // Time constants
    private let dayInSeconds: TimeInterval = 60 * 60 * 24
    private let yearInSeconds: TimeInterval = 60 * 60 * 24 * 365
    
    // Onboarding questionnaire fields
    @Published var university = ""
    @Published var major = ""
    @Published var programLevel = ProgramLevel.masters.rawValue
    @Published var programStartDate = Date()
    @Published var programEndDate: Date
    @Published var i20ExpiryDate: Date
    @Published var hasOptApplied = false
    @Published var isSevisActive = true
    @Published var visaExpiryDate: Date?
    
    private let authService = AuthService.shared
    
    init() {
        // Initialize dates with clearer calculations
        let twoYearsFromNow = Date().addingTimeInterval(yearInSeconds * 2)
        self.programEndDate = twoYearsFromNow
        
        let oneMonthInSeconds = dayInSeconds * 30
        self.i20ExpiryDate = twoYearsFromNow.addingTimeInterval(oneMonthInSeconds)
        
        self.visaExpiryDate = Date().addingTimeInterval(yearInSeconds * 5)
        
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        if let user = authService.getCurrentUser() {
            self.user = user
            self.isLoggedIn = true
            
            // Load user data into form fields
            self.university = user.university
            self.major = user.major
            self.programLevel = user.programLevel
            self.programStartDate = user.programStartDate
            self.programEndDate = user.programEndDate
            self.i20ExpiryDate = user.i20ExpiryDate
            self.hasOptApplied = user.hasOptApplied
            self.isSevisActive = user.isSevisActive
            self.visaExpiryDate = user.visaExpiryDate
        } else {
            self.isLoggedIn = false
            self.user = nil
        }
    }
    
    func signIn() -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            return false
        }
        
        guard email.contains("@") && email.hasSuffix(".edu") else {
            errorMessage = "Please use a valid college email (.edu)"
            return false
        }
        
        let success = authService.signIn(email: email, password: password)
        if success {
            checkLoginStatus()
            if user?.university.isEmpty ?? true {
                showOnboarding = true
            }
        } else {
            errorMessage = "Invalid email or password"
        }
        return success
    }
    
    func signUp() -> Bool {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        guard email.contains("@") && email.hasSuffix(".edu") else {
            errorMessage = "Please use a valid college email (.edu)"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        let success = authService.signUp(name: name, email: email, password: password)
        if success {
            checkLoginStatus()
            showOnboarding = true
        } else {
            errorMessage = "Failed to create account"
        }
        return success
    }
    
    func signOut() {
        authService.signOut()
        checkLoginStatus()
    }
    
    func updateProfile() -> Bool {
        guard let currentUser = user else { return false }
        
        let updatedUser = User(
            id: currentUser.id,
            name: currentUser.name,
            email: currentUser.email,
            university: university,
            major: major,
            programLevel: programLevel,
            programStartDate: programStartDate,
            programEndDate: programEndDate,
            i20ExpiryDate: i20ExpiryDate,
            hasOptApplied: hasOptApplied,
            isSevisActive: isSevisActive,
            visaExpiryDate: visaExpiryDate,
            photoURL: currentUser.photoURL,
            notificationsEnabled: currentUser.notificationsEnabled,
            reminderDays: currentUser.reminderDays
        )
        
        authService.updateProfile(updatedUser)
        checkLoginStatus()
        return true
    }
    
    func getUserDeadlines() -> [String] {
        var deadlines: [String] = []
        
        // Check I-20 expiration
        if let user = user {
            let calendar = Calendar.current
            let today = Date()
            
            // I-20 expiration check
            let i20DaysRemaining = calendar.dateComponents([.day], from: today, to: user.i20ExpiryDate).day ?? 0
            if i20DaysRemaining < 60 {
                deadlines.append("I-20 expires in \(i20DaysRemaining) days")
            }
            
            // Program end date - OPT application window
            let programEndDaysRemaining = calendar.dateComponents([.day], from: today, to: user.programEndDate).day ?? 0
            if programEndDaysRemaining <= 90 && !user.hasOptApplied {
                deadlines.append("OPT application window open (\(programEndDaysRemaining) days until program end)")
            }
            
            // Visa expiration check
            if let visaExpiry = user.visaExpiryDate {
                let visaDaysRemaining = calendar.dateComponents([.day], from: today, to: visaExpiry).day ?? 0
                if visaDaysRemaining < 180 {
                    deadlines.append("Visa expires in \(visaDaysRemaining) days")
                }
            }
        }
        
        return deadlines
    }
} 