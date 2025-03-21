import SwiftUI

struct QuestionCategoriesView: View {
    @StateObject private var viewModel = QuestionCategoriesViewModel()
    var onQuestionSelect: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Question Categories")
                    .font(.headline)
                
                Spacer()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            
            // Categories list
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .padding()
                Spacer()
            } else if viewModel.categories.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("No Categories")
                        .font(.headline)
                    
                    Text("Question categories are not available at this time")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            QuestionCategoryView(
                                category: category,
                                questions: viewModel.questions(for: category),
                                onQuestionSelect: onQuestionSelect
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .onAppear {
            viewModel.fetchQuestionCategories()
        }
    }
}

struct QuestionCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionCategoriesView(onQuestionSelect: { _ in })
            .padding()
            .previewLayout(.sizeThatFits)
            .frame(height: 400)
    }
} 