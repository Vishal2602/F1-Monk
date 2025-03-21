import Foundation
import Combine

class QuestionCategoriesViewModel: ObservableObject {
    @Published var categorizedQuestions: [String: [QAResponse]] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let dataService = DataService.shared
    
    // Add a convenience method for consistency
    func loadCategories() {
        fetchQuestionCategories()
    }
    
    func fetchQuestionCategories() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let qaResponses = try await dataService.fetchQAResponses()
                
                // Group questions by category
                let grouped = Dictionary(grouping: qaResponses) { $0.category }
                
                await MainActor.run {
                    self.categorizedQuestions = grouped
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load question categories. Please try again."
                    self.isLoading = false
                }
            }
        }
    }
    
    var categories: [String] {
        return Array(categorizedQuestions.keys).sorted()
    }
    
    func questions(for category: String) -> [QAResponse] {
        return categorizedQuestions[category] ?? []
    }
} 