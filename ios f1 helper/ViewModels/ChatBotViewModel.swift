import Foundation
import Combine

class ChatBotViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var currentEmotion: MascotEmotion = .happy
    
    private let chatService = ChatService.shared
    private let profileViewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Listen for profile changes
        profileViewModel.$user
            .sink { [weak self] _ in
                self?.updateWelcomeMessage()
            }
            .store(in: &cancellables)
        
        // Add welcome message
        loadInitialMessages()
    }
    
    func loadInitialMessages() {
        messages.append(Message(
            id: UUID().uuidString,
            content: getWelcomeMessage(),
            isFromUser: false,
            timestamp: Date()
        ))
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(
            id: UUID().uuidString,
            content: inputText,
            isFromUser: true,
            timestamp: Date()
        )
        
        messages.append(userMessage)
        
        let userInput = inputText
        inputText = ""
        isLoading = true
        
        Task {
            do {
                // Incorporate profile data in the chat context if available
                var context = ""
                if let user = profileViewModel.user {
                    context = """
                    User profile context:
                    - University: \(user.university)
                    - Major: \(user.major)
                    - Program level: \(user.programLevel)
                    - Program end date: \(formatDate(user.programEndDate) ?? "Unknown")
                    - I-20 expiry: \(formatDate(user.i20ExpiryDate) ?? "Unknown")
                    - Has applied for OPT: \(user.hasOptApplied ? "Yes" : "No")
                    - SEVIS status: \(user.isSevisActive ? "Active" : "Needs attention")
                    """
                }
                
                let response = try await chatService.getBotResponse(for: userInput, context: context)
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    let botMessage = Message(
                        id: UUID().uuidString,
                        content: response,
                        isFromUser: false,
                        timestamp: Date()
                    )
                    
                    self.messages.append(botMessage)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    let errorMessage = Message(
                        id: UUID().uuidString,
                        content: "Sorry, I'm having trouble responding right now. Please try again later.",
                        isFromUser: false,
                        timestamp: Date()
                    )
                    
                    self.messages.append(errorMessage)
                }
            }
        }
    }
    
    private func getWelcomeMessage() -> String {
        if let user = profileViewModel.user {
            // Personalized welcome for logged-in users
            let firstName = user.name.components(separatedBy: " ").first ?? user.name
            
            // Build a personalized message based on user profile
            var message = "Hello \(firstName)! I'm your F1 Monk assistant. "
            
            // Check if there are any deadlines to highlight
            let deadlines = profileViewModel.getUserDeadlines()
            if !deadlines.isEmpty {
                message += "I notice you have some upcoming F1 deadlines:\n\n"
                deadlines.forEach { message += "• \($0)\n" }
                message += "\nHow can I help you with these or any other F1 visa questions today?"
            } else {
                message += "How can I help you with your F1 visa questions today?"
            }
            
            return message
        } else {
            // Generic welcome for non-logged in users
            return "Hello! I'm your F1 Monk assistant. I can answer questions about F1 visa requirements, OPT, CPT, and other student visa topics. How can I help you today?"
        }
    }
    
    private func updateWelcomeMessage() {
        // Update welcome message if it's the first message and user profile changes
        if !messages.isEmpty && !messages[0].isFromUser {
            messages[0] = Message(
                id: messages[0].id,
                content: getWelcomeMessage(),
                isFromUser: false,
                timestamp: messages[0].timestamp
            )
        }
    }
    
    private func formatDate(_ date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    func setQuestion(_ question: String) {
        inputText = question
        sendMessage()
    }
} 