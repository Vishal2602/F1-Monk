import Foundation
import Combine

class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    @Published var unreadCount: Int = 0
    
    private let dataService = DataService.shared
    private let profileViewModel = ProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Listen for profile changes
        profileViewModel.$user
            .sink { [weak self] _ in
                self?.updateProfileNotifications()
            }
            .store(in: &cancellables)
    }
    
    func fetchNotifications() {
        Task { [weak self] in
            do {
                guard let self = self else { return }
                let fetchedNotifications = try await dataService.fetchNotifications()
                
                DispatchQueue.main.async {
                    self.notifications = fetchedNotifications
                    self.unreadCount = fetchedNotifications.filter { $0.priority == .high }.count
                    self.updateProfileNotifications()
                }
            } catch {
                print("Error fetching notifications: \(error)")
            }
        }
    }
    
    func markAsRead(_ notification: Notification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            var updatedNotification = notification
            updatedNotification.isRead = true
            
            notifications[index] = updatedNotification
            
            // Update unread count
            unreadCount = notifications.filter { $0.priority == .high && !$0.isRead }.count
        }
    }
    
    // Generates notifications from profile data
    private func updateProfileNotifications() {
        // Get profile deadlines
        let profileDeadlines = profileViewModel.getUserDeadlines()
        
        // If there are no profile deadlines or user isn't logged in, return
        if profileDeadlines.isEmpty || !profileViewModel.isLoggedIn {
            return
        }
        
        // Create notifications for each profile deadline
        for (index, deadline) in profileDeadlines.enumerated() {
            // Check if a notification with this deadline text already exists
            if !notifications.contains(where: { $0.content.contains(deadline) }) {
                let notificationId = Int.max - index // Use a high number to avoid ID conflicts
                
                let title: String
                let priority: Notification.NotificationPriority
                
                if deadline.contains("I-20 expires") {
                    title = "I-20 Extension Reminder"
                    priority = .high
                } else if deadline.contains("OPT application") {
                    title = "OPT Application Deadline"
                    priority = .high
                } else if deadline.contains("Visa expires") {
                    title = "Visa Renewal Reminder"
                    priority = .normal
                } else {
                    title = "F1 Status Alert"
                    priority = .normal
                }
                
                let notification = Notification(
                    id: notificationId,
                    title: title,
                    content: deadline,
                    priority: priority,
                    date: Date()
                )
                
                DispatchQueue.main.async {
                    self.notifications.append(notification)
                    if priority == .high {
                        self.unreadCount += 1
                    }
                }
            }
        }
    }
    
    func clearAll() {
        notifications.removeAll()
        unreadCount = 0
    }
} 