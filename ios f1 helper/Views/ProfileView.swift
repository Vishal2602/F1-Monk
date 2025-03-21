import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingQuestionnaire = false
    @State private var showingLoginView = false
    @State private var isSignUp = false
    
    var body: some View {
        NavigationView {
            if viewModel.isLoggedIn {
            ScrollView {
                    VStack(spacing: 20) {
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
                    }
                    .padding(.vertical)
                }
                .navigationTitle("My Profile")
                .sheet(isPresented: $showingQuestionnaire) {
                    ProfileQuestionnaireView(viewModel: viewModel)
                }
                .sheet(isPresented: $viewModel.showOnboarding) {
                    ProfileQuestionnaireView(viewModel: viewModel)
                        .interactiveDismissDisabled(true)
                }
            } else {
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
                    
                    Button(action: {
                        showingLoginView = true
                        isSignUp = false
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: {
                        showingLoginView = true
                        isSignUp = true
                    }) {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                }
                .navigationTitle("Profile")
                .sheet(isPresented: $showingLoginView) {
                    if isSignUp {
                        SignUpView(viewModel: viewModel)
                    } else {
                        SignInView(viewModel: viewModel)
                    }
                }
            }
        }
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
                showingQuestionnaire = true
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
}

struct SignInView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sign in with your college email")
                    .font(.headline)
                    .padding(.top)
                
                VStack(spacing: 15) {
                    TextField("College Email (.edu)", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: {
                    if viewModel.signIn() {
                        dismiss()
                    }
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SignUpView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create your F1 Monk account")
                    .font(.headline)
                    .padding(.top)
                
                VStack(spacing: 15) {
                    TextField("Full Name", text: $viewModel.name)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    TextField("College Email (.edu)", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    SecureField("Password (min 6 characters)", text: $viewModel.password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
        Button(action: {
                    if viewModel.signUp() {
                        dismiss()
                    }
                }) {
                    Text("Create Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Text("By creating an account, you agree to our Terms of Service and Privacy Policy")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ProfileQuestionnaireView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $currentPage) {
                    // Page 1: Basic Info
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Academic Information")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("This information helps us provide personalized F1 visa guidance.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Group {
                            TextField("University Name", text: $viewModel.university)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            
                            TextField("Major/Program", text: $viewModel.major)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            
                            Picker("Program Level", selection: $viewModel.programLevel) {
                                ForEach(ProgramLevel.allCases, id: \.self) { level in
                                    Text(level.rawValue).tag(level.rawValue)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            currentPage = 1
                        }) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .tag(0)
                    
                    // Page 2: Dates
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Program Timeline")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("These dates help us track deadlines and requirements.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Group {
                            VStack(alignment: .leading) {
                                Text("Program Start Date")
                                    .font(.headline)
                                DatePicker("", selection: $viewModel.programStartDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .frame(maxHeight: 400)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Program End Date")
                                    .font(.headline)
                                DatePicker("", selection: $viewModel.programEndDate, in: viewModel.programStartDate..., displayedComponents: .date)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("I-20 Expiry Date")
                                    .font(.headline)
                                DatePicker("", selection: $viewModel.i20ExpiryDate, in: viewModel.programEndDate..., displayedComponents: .date)
                            }
                        }
                        
                        Spacer()
                        
        HStack {
                            Button(action: {
                                currentPage = 0
                            }) {
                                Text("Back")
                                    .font(.headline)
                .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                currentPage = 2
                            }) {
                                Text("Next")
                .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
        }
        .padding()
                    .tag(1)
                    
                    // Page 3: Status
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Visa Status Information")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("This helps us provide relevant guidance for your specific situation.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Toggle("I have applied for OPT", isOn: $viewModel.hasOptApplied)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        
                        Toggle("My SEVIS record is active", isOn: $viewModel.isSevisActive)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text("Visa Expiry Date (if applicable)")
                                .font(.headline)
                            DatePicker("", selection: Binding(
                                get: { viewModel.visaExpiryDate ?? Date() },
                                set: { viewModel.visaExpiryDate = $0 }
                            ), displayedComponents: .date)
                        }
                        
                        Spacer()
                        
        HStack {
                            Button(action: {
                                currentPage = 1
                            }) {
                                Text("Back")
                                    .font(.headline)
                .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                if viewModel.updateProfile() {
                                    dismiss()
                                }
                            }) {
                                Text("Save Profile")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
        }
        .padding()
                    .tag(2)
    }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    
                // Page indicator
            HStack {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Your F1 Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !viewModel.showOnboarding {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
} 