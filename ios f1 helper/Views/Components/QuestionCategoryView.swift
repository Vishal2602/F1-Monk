import SwiftUI

struct QuestionCategoryView: View {
    let category: String
    let questions: [QAResponse]
    let onQuestionSelect: (String) -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Category header
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    CategoryIcon(category: category)
                        .frame(width: 32, height: 32)
                    
                    Text(Constants.CategoryLabels.label(for: category))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14, weight: .medium))
                        .animation(.easeInOut, value: isExpanded)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Questions list
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(questions) { qa in
                        Button(action: {
                            onQuestionSelect(qa.question)
                        }) {
                            HStack {
                                Text(qa.question)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.forward")
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if qa.id != questions.last?.id {
                            Divider()
                                .padding(.leading, 16)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.top, 1)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}

struct CategoryIcon: View {
    let category: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
            
            Image(systemName: iconName)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(iconColor)
        }
    }
    
    private var backgroundColor: Color {
        Constants.CategoryColors.color(for: category).opacity(0.2)
    }
    
    private var iconColor: Color {
        Constants.CategoryColors.color(for: category)
    }
    
    private var iconName: String {
        switch category {
        case "status_maintenance":
            return "doc.text"
        case "employment":
            return "briefcase"
        case "academic":
            return "graduationcap"
        case "travel":
            return "airplane"
        case "health_insurance":
            return "heart"
        case "program_extension":
            return "calendar"
        default:
            return "questionmark"
        }
    }
}

struct QuestionCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            QuestionCategoryView(
                category: "academic",
                questions: [
                    QAResponse(id: 1, question: "How many credits do I need to maintain F-1 status?", answer: "Answer", category: "academic"),
                    QAResponse(id: 2, question: "Can I take online classes?", answer: "Answer", category: "academic")
                ],
                onQuestionSelect: { _ in }
            )
            
            QuestionCategoryView(
                category: "employment",
                questions: [
                    QAResponse(id: 3, question: "Can I work off-campus with an F-1 visa?", answer: "Answer", category: "employment"),
                    QAResponse(id: 4, question: "What is CPT?", answer: "Answer", category: "employment")
                ],
                onQuestionSelect: { _ in }
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .previewLayout(.sizeThatFits)
    }
} 