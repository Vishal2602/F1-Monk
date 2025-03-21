import Foundation
import SwiftUI

enum Constants {
    // API Endpoints
    enum API {
        static let baseURL = "https://f1visahelper-api.example.com"
        static let notifications = "/api/notifications"
        static let qa = "/api/qa"
        static let analytics = "/api/analytics"
        static let topAnalytics = "/api/analytics/top"
        static let trackAnalytics = "/api/analytics/track"
    }
    
    // Meeting Links
    enum MeetingLinks {
        static let academic = "https://calendly.com/f1monk/academic"
        static let visa = "https://calendly.com/f1monk/visa"
        static let career = "https://calendly.com/f1monk/career"
    }
    
    // Category Labels
    enum CategoryLabels {
        static let statusMaintenance = "Status Maintenance"
        static let employment = "Employment"
        static let academic = "Academic"
        static let travel = "Travel"
        static let healthInsurance = "Health Insurance"
        static let programExtension = "Program Extension"
        
        static func label(for category: String) -> String {
            switch category {
            case "status_maintenance": return statusMaintenance
            case "employment": return employment
            case "academic": return academic
            case "travel": return travel
            case "health_insurance": return healthInsurance
            case "program_extension": return programExtension
            default: return category.capitalized
            }
        }
    }
    
    // Category Colors
    enum CategoryColors {
        static func color(for category: String) -> Color {
            switch category {
            case "status_maintenance": return .indigo
            case "employment": return .green
            case "academic": return .blue
            case "travel": return .purple
            case "health_insurance": return .red
            case "program_extension": return .orange
            default: return .gray
            }
        }
    }
    
    // Default Messages
    enum DefaultMessages {
        static let welcomeMessage = "Hi! I'm the F1 Monk. How can I help you today? Feel free to ask me anything about F1 visa requirements, work permits, or academic regulations."
    }
} 
