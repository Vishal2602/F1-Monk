import SwiftUI

struct HomeView: View {
    @StateObject private var notificationViewModel = NotificationViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    // Time of day greeting
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return "Good morning"
        } else if hour < 17 {
            return "Good afternoon"
        } else {
            return "Good evening"
        }
    }
    
    // Current date formatted
    private var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
    
    // User's name or fallback to Student
    private var displayName: String {
        if let user = profileViewModel.user {
            return user.name.components(separatedBy: " ").first ?? user.name
        }
        return "Student"
    }
    
    // Status indicator for F1 visa status
    private var isActiveStatus: Bool {
        return profileViewModel.user?.isSevisActive ?? true
    }
    
    // Number of upcoming deadlines/events from notifications and profile deadlines
    private var upcomingDeadlinesCount: Int {
        return notificationViewModel.notifications.count + profileViewModel.getUserDeadlines().count
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header with greeting, date, and mascot
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(dateFormatted)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("\(greeting),")
                            .font(.system(size: 34, weight: .bold))
                        
                        Text(displayName)
                            .font(.custom("Baskerville-BoldItalic", size: 40))
                            .foregroundColor(.white)
                            .padding(.top, -5)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Profile deadlines (if logged in)
                if profileViewModel.isLoggedIn && !profileViewModel.getUserDeadlines().isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("F1 Status Deadlines")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        // Profile deadlines
                        ForEach(profileViewModel.getUserDeadlines(), id: \.self) { deadline in
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.orange)
                                    .frame(width: 24)
                                
                                Text(deadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(Color(.systemGray6).opacity(0.3))
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Upcoming deadlines summary
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(upcomingDeadlinesCount) events from \(formattedTimeRange())")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // List of upcoming deadlines
                    ForEach(notificationViewModel.notifications.prefix(2)) { notification in
                        HStack {
                            // Icon based on notification type
                            let iconName = notificationIconName(for: notification.title)
                            if !iconName.isEmpty {
                                Image(systemName: iconName)
                                    .foregroundColor(.blue)
                                    .frame(width: 24)
                            }
                            
                            Text(notification.title)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text(formattedTime(notification.date))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    
                    // View Timeline button
                    NavigationLink(destination: TimelineView()) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                            
                            Text("View Full Timeline")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                }
                
                // Things due today
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(notificationViewModel.notifications.filter { Calendar.current.isDateInToday($0.date) }.count) things due today")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // Due today items
                    ForEach(notificationViewModel.notifications.filter { Calendar.current.isDateInToday($0.date) }.prefix(2)) { notification in
                        HStack {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.secondary, lineWidth: 1.5)
                                )
                            
                            Text(notification.content.prefix(50) + (notification.content.count > 50 ? "..." : ""))
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text(formattedTime(notification.date))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                }
                
                // Profile status summary (if logged in)
                if profileViewModel.isLoggedIn {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your F1 Summary")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            profileInfoRow(title: "University", value: profileViewModel.user?.university ?? "Not specified")
                            profileInfoRow(title: "I-20 Expires", value: formatDate(profileViewModel.user?.i20ExpiryDate) ?? "Not specified")
                            profileInfoRow(title: "OPT Status", value: profileViewModel.user?.hasOptApplied ?? false ? "Applied" : "Not Applied")
                        }
                        .padding()
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                }
                
                // Appointment scheduling
                VStack(alignment: .leading, spacing: 16) {
                    Text("Schedule an Appointment")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    HStack(spacing: 16) {
                        AppointmentButton(
                            title: "Academic\nAdvisor",
                            icon: "graduationcap",
                            url: Constants.MeetingLinks.academic
                        )
                        
                        AppointmentButton(
                            title: "Visa\nAdvisor",
                            icon: "doc.text",
                            url: Constants.MeetingLinks.visa
                        )
                        
                        AppointmentButton(
                            title: "Career\nAdvisor",
                            icon: "briefcase",
                            url: Constants.MeetingLinks.career
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Important alerts
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.blue)
                        
                        Text("Important Alerts")
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    ForEach(notificationViewModel.notifications.prefix(2)) { notification in
                        NotificationCard(notification: notification)
                            .padding(.horizontal)
                    }
                }
                
                // Sign In prompt (if not logged in)
                if !profileViewModel.isLoggedIn {
                    VStack(spacing: 16) {
                        Text("Set Up Your F1 Profile")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Text("Create a profile to receive personalized deadline reminders and document tracking for your F1 visa.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        NavigationLink(destination: ProfileView()) {
                            HStack {
                                Image(systemName: "person.crop.circle.badge.plus")
                                Text("Create Profile")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                // Need help section
                VStack(spacing: 16) {
                    Text("Need Help?")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Text("If you can't find the information you need, contact your DSO or international student office.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        if let url = URL(string: "mailto:international@university.edu") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Contact Support")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Disclaimer text
                Text("Disclaimer: This bot provides general guidance only. Please consult your DSO for official advice.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
        .onAppear {
            notificationViewModel.fetchNotifications()
            profileViewModel.checkLoginStatus()
        }
    }
    
    // Helper methods
    private func formattedTimeRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        
        let now = Date()
        let calendar = Calendar.current
        let dayEnd = calendar.date(bySettingHour: 18, minute: 30, second: 0, of: now)!
        
        let startTime = formatter.string(from: calendar.date(bySettingHour: 7, minute: 30, second: 0, of: now)!)
        let endTime = formatter.string(from: dayEnd)
        
        return "\(startTime.lowercased()) - \(endTime.lowercased())"
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter.string(from: date).lowercased()
    }
    
    private func notificationIconName(for title: String) -> String {
        if title.contains("OPT") {
            return "doc.text.fill"
        } else if title.contains("I-20") {
            return "doc.fill"
        } else if title.contains("Tax") {
            return "dollarsign.circle.fill"
        } else if title.contains("Health") || title.contains("Insurance") {
            return "heart.fill"
        } else {
            return "calendar"
        }
    }
    
    private func profileInfoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.white)
        }
    }
    
    private func formatDate(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct AppointmentButton: View {
    let title: String
    let icon: String
    let url: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .preferredColorScheme(.dark)
        }
    }
}
