import SwiftUI

struct NotificationBoardView: View {
    @StateObject private var viewModel = NotificationViewModel()
    @State private var selectedFilter: NotificationFilter = .all
    
    enum NotificationFilter {
        case all
        case high
        case normal
        case low
        
        func filter(_ notifications: [Notification]) -> [Notification] {
            switch self {
            case .all:
                return notifications
            case .high:
                return notifications.filter { $0.priority == .high }
            case .normal:
                return notifications.filter { $0.priority == .normal }
            case .low:
                return notifications.filter { $0.priority == .low }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter Selector
            HStack {
                Spacer()
                
                Button(action: {
                    selectedFilter = .all
                }) {
                    Text("All")
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedFilter == .all ? Color.blue : Color.clear)
                        .foregroundColor(selectedFilter == .all ? .white : .primary)
                        .cornerRadius(20)
                }
                
                Button(action: {
                    selectedFilter = .high
                }) {
                    Text("Important")
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedFilter == .high ? Color.red : Color.clear)
                        .foregroundColor(selectedFilter == .high ? .white : .primary)
                        .cornerRadius(20)
                }
                
                Button(action: {
                    selectedFilter = .normal
                }) {
                    Text("Normal")
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedFilter == .normal ? Color.orange : Color.clear)
                        .foregroundColor(selectedFilter == .normal ? .white : .primary)
                        .cornerRadius(20)
                }
                
                Spacer()
            }
            .padding(.top, 8)
            .padding(.bottom, 16)
            .background(Color.black.opacity(0.2))
            
            // Notifications List
            if filteredNotifications.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredNotifications) { notification in
                            NotificationCard(notification: notification)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.clearAll()
                }) {
                    Text("Clear All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            viewModel.fetchNotifications()
        }
    }
    
    private var filteredNotifications: [Notification] {
        selectedFilter.filter(viewModel.notifications)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "bell.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
            
            Text("No Notifications")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("When you receive notifications about your F1 status, they will appear here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct NotificationBoardView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBoardView()
            .padding()
            .previewLayout(.sizeThatFits)
            .frame(height: 400)
    }
} 