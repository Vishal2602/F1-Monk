import Foundation

enum ChatError: Error {
    case invalidResponse
    case apiError(String)
}

struct ChatResponse: Codable {
    let response: String
    let intent: String?
    let confidence: Double?
}

class ChatService {
    static let shared = ChatService()
    
    private let networkService = NetworkService.shared
    private let dataService = DataService.shared
    
    private init() {}
    
    // For now, we'll simulate the AI response
    // In a real app, this would connect to the backend AI service
    func getResponse(for message: String) async throws -> ChatResponse {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Simple pattern matching for demo purposes
        if isGreeting(message) {
            return ChatResponse(
                response: getGreetingResponse(),
                intent: "greeting",
                confidence: 0.95
            )
        }
        
        // Check for keywords to simulate intent detection
        if message.lowercased().contains("opt") || message.lowercased().contains("work") {
            return ChatResponse(
                response: "Optional Practical Training (OPT) allows F-1 students to work in their field of study for up to 12 months after completing their academic program. STEM students may be eligible for a 24-month extension.",
                intent: "employment",
                confidence: 0.85
            )
        }
        
        if message.lowercased().contains("travel") || message.lowercased().contains("vacation") {
            return ChatResponse(
                response: "F-1 students can travel outside the US during their program, but must have a valid visa, I-20 signed for travel within the last year, and proof of enrollment to re-enter. Always check travel advisories before planning international travel.",
                intent: "travel",
                confidence: 0.82
            )
        }
        
        if message.lowercased().contains("credit") || message.lowercased().contains("course") || message.lowercased().contains("class") {
            return ChatResponse(
                response: "F-1 students must maintain full-time enrollment, which typically means at least 12 credit hours for undergraduates and 9 for graduates per semester. Exceptions may be granted by your DSO for specific circumstances.",
                intent: "academic",
                confidence: 0.78
            )
        }
        
        // Default response
        return ChatResponse(
            response: "I understand you're asking about F-1 visa matters. Could you provide more specific details about your question so I can give you the most accurate information?",
            intent: nil,
            confidence: 0.5
        )
    }
    
    private func isGreeting(_ text: String) -> Bool {
        let greetingPatterns = [
            "^hi\\b",
            "^hello\\b",
            "^hey\\b",
            "^greetings",
            "^good\\s*(morning|afternoon|evening)",
            "^howdy\\b"
        ]
        
        return greetingPatterns.contains { pattern in
            text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
        }
    }
    
    private func getGreetingResponse() -> String {
        let responses = [
            "Hello! How can I assist you with your F1 visa questions today?",
            "Hi there! I'm here to help with any F1 visa related questions you might have.",
            "Greetings! What would you like to know about F1 visa regulations?",
            "Hello! I'm the F1 Monk. What questions do you have about studying in the US?"
        ]
        
        return responses.randomElement() ?? responses[0]
    }
    
    // Simulates a response from an AI chatbot
    func getBotResponse(for message: String, context: String = "") async throws -> String {
        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        
        // Lowercase for easier matching
        let lowercased = message.lowercased()
        
        // Context-aware responses based on user profile data
        if !context.isEmpty {
            print("Using context: \(context)")
            // In a real app, this context would be sent to the AI model
        }
        
        // Check for OPT related questions
        if lowercased.contains("opt") || lowercased.contains("optional practical training") {
            if lowercased.contains("apply") || lowercased.contains("application") || lowercased.contains("how") {
                return "To apply for OPT, you need to:\n\n1. Request an I-20 recommendation from your DSO\n2. File Form I-765 with USCIS\n3. Pay the application fee\n4. Submit supporting documents including photos and copies of your immigration documents\n\nThe application window opens 90 days before your program end date and closes 60 days after."
            } else if lowercased.contains("documents") || lowercased.contains("need") {
                return "For OPT applications, you'll need:\n\n- Form I-765\n- OPT I-20 with DSO recommendation\n- Application fee payment\n- Two passport-style photos\n- Copy of your passport\n- Copy of your visa\n- Copy of your I-94\n- Copies of previous EADs (if applicable)"
            } else if lowercased.contains("time") || lowercased.contains("processing") || lowercased.contains("long") {
                return "OPT processing times typically range from 90 to 150 days. USCIS provides case status updates on their website. You cannot begin working until you receive your EAD card."
            }
            return "OPT (Optional Practical Training) allows F-1 students to work in their field of study for up to 12 months after completing their program. STEM degree holders may be eligible for a 24-month extension."
        }
        
        // I-20 related questions
        if lowercased.contains("i-20") || lowercased.contains("i20") {
            if lowercased.contains("extend") || lowercased.contains("extension") {
                return "To extend your I-20:\n\n1. Contact your DSO before the document expires\n2. Provide academic justification for the extension\n3. Show updated financial documentation\n4. Your DSO will issue a new I-20 with the extended end date\n\nYou must apply before your current I-20 expires or you'll fall out of status."
            } else if lowercased.contains("travel") || lowercased.contains("signature") {
                return "For international travel, ensure your I-20 has a valid travel signature on page 2. This signature is typically valid for 12 months while you're in an active program, or 6 months while on OPT. Request a new signature from your DSO before traveling if needed."
            }
            return "Your I-20 is a critical document that certifies your eligibility for F-1 status. It contains your program information, funding details, and SEVIS ID. Always keep it valid and with you when traveling internationally."
        }
        
        // CPT related questions
        if lowercased.contains("cpt") || lowercased.contains("curricular practical training") {
            return "Curricular Practical Training (CPT) is work authorization for F-1 students that's an integral part of your curriculum. To qualify:\n\n1. You must have completed one academic year (exceptions exist for graduate programs requiring immediate CPT)\n2. The internship/job must be related to your major\n3. You must receive academic credit or the training must be required for your degree\n\nYour DSO must authorize CPT on your I-20 before you begin working."
        }
        
        // Visa related questions
        if lowercased.contains("visa") {
            if lowercased.contains("renew") || lowercased.contains("renewal") {
                return "To renew your F-1 visa:\n\n1. Your I-20 must be valid and have a recent travel signature\n2. Schedule an appointment at a U.S. consulate (preferably in your home country)\n3. Pay the visa application fee\n4. Complete the DS-160 form\n5. Attend your visa interview with all required documents\n\nNote that you cannot renew an F-1 visa while inside the United States."
            } else if lowercased.contains("interview") {
                return "For your F-1 visa interview, prepare to discuss:\n\n1. Your study plans and why you chose your specific program\n2. How your studies fit into your career plans\n3. Your ties to your home country\n4. Your financial ability to support yourself\n\nBring all required documents including your I-20, financial proof, and acceptance letter."
            }
            return "The F-1 visa allows you to enter the U.S. as a student. While your visa can expire while you're in the U.S., your F-1 status can remain valid as long as you maintain a valid I-20 and follow all F-1 regulations."
        }
        
        // Status maintenance questions
        if lowercased.contains("maintain") || lowercased.contains("status") || lowercased.contains("full time") || lowercased.contains("fulltime") {
            return "To maintain F-1 status:\n\n1. Maintain full-time enrollment (12+ credits for undergrads, 9+ for graduates)\n2. Make normal academic progress toward your degree\n3. Only work with proper authorization\n4. Keep your I-20 valid and current\n5. Maintain valid health insurance\n6. Report any changes in address or major to your DSO\n7. Don't stay in the U.S. beyond your grace period\n\nViolating these requirements can lead to status termination."
        }
        
        // Default response for questions we don't have specific answers for
        return "That's a good question about F-1 student visas. For specific advice tailored to your situation, I recommend contacting your university's Designated School Official (DSO) or International Student Office. They can provide guidance based on your specific circumstances and university policies."
    }
    
    // Tracks questions for analytics
    func trackQuestion(question: String, category: String) async {
        // In a real app, this would send the data to a backend for analytics
        print("Question tracked: \(question) in category: \(category)")
    }
} 
