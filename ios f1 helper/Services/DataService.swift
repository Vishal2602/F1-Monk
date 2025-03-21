import Foundation

class DataService {
    static let shared = DataService()
    
    private init() {}
    
    // MARK: - Notifications
    
    func fetchNotifications() async throws -> [Notification] {
        // In a real app, this would use the NetworkService to fetch from the API
        // For now, we'll return mock data
        return [
            Notification(
                id: 1,
                title: "OPT Application Deadline",
                content: "The deadline for OPT applications for May graduates is approaching. Submit your application at least 90 days before your program end date.",
                priority: .high,
                date: Date()
            ),
            Notification(
                id: 2,
                title: "I-20 Extension Reminder",
                content: "If your I-20 is expiring within the next 60 days, please contact your DSO to discuss extension options.",
                priority: .normal,
                date: Date().addingTimeInterval(-86400 * 2) // 2 days ago
            ),
            Notification(
                id: 3,
                title: "Tax Filing Season",
                content: "All F-1 students must file Form 8843, even if you had no income. Those who worked must also file federal and state tax returns.",
                priority: .normal,
                date: Date().addingTimeInterval(-86400 * 5) // 5 days ago
            ),
            Notification(
                id: 4,
                title: "Health Insurance Enrollment",
                content: "Open enrollment for student health insurance begins next week. All international students are required to have health insurance coverage.",
                priority: .low,
                date: Date().addingTimeInterval(-86400 * 10) // 10 days ago
            )
        ]
    }
    
    // MARK: - QA Responses
    
    func fetchQAResponses() async throws -> [QAResponse] {
        // In a real app, this would use the NetworkService to fetch from the API
        // For now, we'll return mock data
        return [
            QAResponse(
                id: 1,
                question: "How many credits do I need to maintain F-1 status?",
                answer: "Undergraduate students must take at least 12 credit hours per semester, and graduate students must take at least 9 credit hours per semester to maintain full-time status.",
                category: "academic"
            ),
            QAResponse(
                id: 2,
                question: "Can I work off-campus with an F-1 visa?",
                answer: "F-1 students can work off-campus through CPT or OPT. CPT is for curricular training during your program, while OPT is typically used after completion of your degree.",
                category: "employment"
            ),
            QAResponse(
                id: 3,
                question: "What happens if my I-20 expires?",
                answer: "If your I-20 expires while you're still completing your program, you must request an extension before the expiration date. Allowing your I-20 to expire puts you out of status.",
                category: "status_maintenance"
            ),
            QAResponse(
                id: 4,
                question: "Can I travel outside the US during breaks?",
                answer: "Yes, you can travel outside the US during breaks, but you must have a valid visa, a valid I-20 signed for travel, and proof of enrollment to re-enter the US.",
                category: "travel"
            ),
            QAResponse(
                id: 5,
                question: "Do I need health insurance as an F-1 student?",
                answer: "While not required by federal regulations, most universities require international students to have health insurance. Healthcare in the US is expensive, so insurance is strongly recommended.",
                category: "health_insurance"
            ),
            QAResponse(
                id: 6,
                question: "How do I extend my program?",
                answer: "To extend your program, you must contact your DSO before your I-20 expires. You'll need to provide academic justification and updated financial documentation.",
                category: "program_extension"
            )
        ]
    }
    
    func fetchQAByCategory(_ category: String) async throws -> [QAResponse] {
        let allQA = try await fetchQAResponses()
        return allQA.filter { $0.category == category }
    }
    
    // MARK: - Analytics
    
    func fetchQuestionAnalytics() async throws -> [QuestionAnalytics] {
        // In a real app, this would use the NetworkService to fetch from the API
        // For now, we'll return mock data
        return [
            QuestionAnalytics(
                id: 1,
                question: "How many credits do I need to maintain F-1 status?",
                category: "academic",
                count: 42,
                lastAsked: Date().addingTimeInterval(-3600) // 1 hour ago
            ),
            QuestionAnalytics(
                id: 2,
                question: "Can I work off-campus with an F-1 visa?",
                category: "employment",
                count: 38,
                lastAsked: Date().addingTimeInterval(-7200) // 2 hours ago
            ),
            QuestionAnalytics(
                id: 3,
                question: "What happens if my I-20 expires?",
                category: "status_maintenance",
                count: 27,
                lastAsked: Date().addingTimeInterval(-14400) // 4 hours ago
            ),
            QuestionAnalytics(
                id: 4,
                question: "Can I travel outside the US during breaks?",
                category: "travel",
                count: 25,
                lastAsked: Date().addingTimeInterval(-28800) // 8 hours ago
            ),
            QuestionAnalytics(
                id: 5,
                question: "Do I need health insurance as an F-1 student?",
                category: "health_insurance",
                count: 18,
                lastAsked: Date().addingTimeInterval(-86400) // 1 day ago
            ),
            QuestionAnalytics(
                id: 6,
                question: "How do I extend my program?",
                category: "program_extension",
                count: 15,
                lastAsked: Date().addingTimeInterval(-172800) // 2 days ago
            )
        ]
    }
    
    func fetchTopQuestions(limit: Int = 10) async throws -> [QuestionAnalytics] {
        let analytics = try await fetchQuestionAnalytics()
        return Array(analytics.sorted(by: { $0.count > $1.count }).prefix(limit))
    }
} 