import Foundation

struct HelpResource: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let content: String
    let url: String
}

struct FAQ: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
} 