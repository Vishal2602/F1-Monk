import SwiftUI

struct ProfileHelpView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // PROFILE SECTION
                    if viewModel.isLoggedIn {
                        // Profile Header
                        profileHeader
                        
                        // Deadlines Section
                        deadlinesSection
                        
                        // Profile Details
                        profileDetailsSection
                        
                        // Action Buttons
                        actionButtons
                        
                        // Sign Out Button
                        Button(action: {
                            viewModel.signOut()
                        }) {
                            Text("Sign Out")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    } else {
                        // Not logged in view
                        signInPrompt
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    // HELP SECTION HEADER
                    Text("Help & Resources")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Quick Resources
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Resources")
                            .font(.headline)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(helpResources) { resource in
                                HelpResourceCard(resource: resource)
                                    .frame(height: 180)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // FAQs
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Frequently Asked Questions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            ForEach(faqs) { faq in
                                FAQItem(faq: faq)
                                
                                if faq.id != faqs.last?.id {
                                    Divider()
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    
                    // Contact Support
                    VStack(spacing: 16) {
                        Text("Still Need Help?")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Text("If you can't find the information you need, our support team is ready to assist you with any F1 visa questions or concerns.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                if let url = URL(string: "mailto:support@f1monk.com") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "envelope")
                                    Text("Email Support")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                if let url = URL(string: "tel:+1234567890") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "phone")
                                    Text("Call Helpline")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile & Help")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showOnboarding) {
                ProfileQuestionnaireView(viewModel: viewModel)
                    .interactiveDismissDisabled(true)
            }
        }
    }
    
    private var signInPrompt: some View {
        VStack(spacing: 30) {
            // App Logo
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(Color.blue.opacity(0.4))
                    .frame(width: 90, height: 90)
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
            }
            
            Text("F1 Monk Profile")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Sign in to access personalized F1 visa guidance, track important deadlines, and receive customized notifications.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 30)
            
            HStack(spacing: 16) {
                Button(action: {
                    viewModel.showSignInSheet(isSignUp: false)
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.showSignInSheet(isSignUp: true)
                }) {
                    Text("Create Account")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var profileHeader: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Text(viewModel.user?.name.prefix(1).uppercased() ?? "S")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(viewModel.user?.name ?? "Student")
                .font(.title)
                .fontWeight(.bold)
            
            Text(viewModel.user?.email ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("\(viewModel.user?.university ?? "University"), \(viewModel.user?.programLevel ?? "Student")")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    private var deadlinesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Important Deadlines")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(viewModel.getUserDeadlines(), id: \.self) { deadline in
                    HStack {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .foregroundColor(.orange)
                        Text(deadline)
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                if viewModel.getUserDeadlines().isEmpty {
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                        Text("No upcoming deadlines")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
    
    private var profileDetailsSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Program Details")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                infoRow(title: "Major", value: viewModel.user?.major ?? "Not specified")
                infoRow(title: "Program Start", value: formatDate(viewModel.user?.programStartDate) ?? "Not specified")
                infoRow(title: "Program End", value: formatDate(viewModel.user?.programEndDate) ?? "Not specified")
                infoRow(title: "I-20 Expiry", value: formatDate(viewModel.user?.i20ExpiryDate) ?? "Not specified")
                infoRow(title: "Visa Expiry", value: formatDate(viewModel.user?.visaExpiryDate) ?? "Not specified")
                infoRow(title: "SEVIS Status", value: viewModel.user?.isSevisActive ?? false ? "Active" : "Inactive")
                infoRow(title: "OPT Applied", value: viewModel.user?.hasOptApplied ?? false ? "Yes" : "No")
            }
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 10) {
            Button(action: {
                viewModel.showQuestionnaireSheet()
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Update Profile Information")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: {
                // Future feature: Export profile data
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Export My Documents")
                }
                .font(.headline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
            }
            .padding(.horizontal)
        }
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
                .frame(width: 120, alignment: .leading)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
    
    private func formatDate(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    // Help section data
    private let helpResources = [
        HelpResource(
            title: "F1 Visa Resources",
            icon: "doc.text",
            content: "Access official USCIS documents, visa application guides, and student resources.",
            url: "https://www.uscis.gov/working-in-the-united-states/students-and-exchange-visitors"
        ),
        HelpResource(
            title: "Contact DSO",
            icon: "envelope",
            content: "Reach out to your Designated School Official for personalized assistance.",
            url: "mailto:dso@university.edu"
        ),
        HelpResource(
            title: "International Office",
            icon: "phone",
            content: "Call the international student office for immediate support.",
            url: "tel:+1234567890"
        ),
        HelpResource(
            title: "SEVIS Portal",
            icon: "globe",
            content: "Access your SEVIS account to manage your F1 visa status.",
            url: "https://studyinthestates.dhs.gov/sevis-help-hub"
        )
    ]
    
    private let faqs = [
        FAQ(
            question: "How do I maintain my F1 status?",
            answer: "To maintain F1 status, you must: maintain full-time enrollment, make normal academic progress, not work without authorization, keep your I-20 valid, and maintain health insurance coverage."
        ),
        FAQ(
            question: "Can I work off-campus with an F1 visa?",
            answer: "F1 students can work off-campus through authorized programs like CPT (Curricular Practical Training) or OPT (Optional Practical Training). Each requires specific authorization from your DSO or USCIS."
        ),
        FAQ(
            question: "What happens if I drop below full-time enrollment?",
            answer: "Dropping below full-time enrollment without prior DSO approval can result in the termination of your F1 status. If you have extenuating circumstances, consult your DSO before reducing your course load."
        ),
        FAQ(
            question: "How do I extend my I-20?",
            answer: "To extend your I-20, contact your DSO before the document expires. You'll need to provide academic justification and updated financial documentation to receive a new I-20 with an extended end date."
        )
    ]
}

// Helper structures for the Help section are now in Models/HelpResource.swift

struct FAQItem: View {
    let faq: FAQ
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack(alignment: .top) {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.blue)
                        .padding(.top, 2)
                    
                    Text(faq.question)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                        .padding(.top, 2)
                }
            }
            
            if isExpanded {
                Text(faq.answer)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, 28)
                    .padding(.top, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Extension to add sheet presentation methods to ProfileViewModel
extension ProfileViewModel {
    func showQuestionnaireSheet() {
        // In a real implementation, this would show a sheet
        showOnboarding = true
    }
    
    func showSignInSheet(isSignUp: Bool) {
        // In a real implementation, this would show a sign-in or sign-up sheet
        // For now, directly sign in with test data
        if isSignUp {
            _ = signUp()
        } else {
            _ = signIn()
        }
    }
}

struct ProfileHelpView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHelpView()
            .preferredColorScheme(.dark)
    }
} 