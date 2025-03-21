import SwiftUI

struct MainTabView: View {
    @StateObject private var chatBotViewModel = ChatBotViewModel()
    @StateObject private var notificationViewModel = NotificationViewModel()
    @StateObject private var questionCategoriesViewModel = QuestionCategoriesViewModel()
    
    @State private var selectedTab = 0
    
    init() {
        // Customize tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        // Customize tab item appearance
        let itemAppearance = UITabBarItemAppearance(style: .stacked)
        itemAppearance.normal.iconColor = UIColor.systemBlue.withAlphaComponent(0.6)
        itemAppearance.selected.iconColor = UIColor.systemBlue
        
        // Apply negative horizontal offset to bring text closer to icon
        // Reduce vertical offset to minimize space
        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Set tab bar background color
        UITabBar.appearance().barTintColor = .black
        
        // Minimal spacing between items
        UITabBar.appearance().itemPositioning = .fill
        UITabBar.appearance().itemSpacing = 0
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeView()
                .environmentObject(chatBotViewModel)
                .tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        Image(systemName: "house.fill")
                    }
                }
                .tag(0)
            
            // Chat Tab
            ChatBotView()
                .tabItem {
                    Label {
                        Text("Chat")
                    } icon: {
                        Image(systemName: "message.fill")
                    }
                }
                .tag(1)
            
            // Timeline Tab
            TimelineView()
                .tabItem {
                    Label {
                        Text("Timeline")
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
                .tag(2)
            
            // Notifications Tab
            NotificationBoardView()
                .tabItem {
                    Label {
                        Text("Alerts")
                    } icon: {
                        Image(systemName: "bell.fill")
                    }
                }
                .badge(notificationViewModel.unreadCount)
                .tag(3)
            
            // Profile & Help Tab (Combined)
            ProfileHelpView()
                .tabItem {
                    Label {
                        Text("Profile")
                    } icon: {
                        Image(systemName: "person.fill")
                    }
                }
                .tag(4)
        }
        .accentColor(.blue)
        .preferredColorScheme(.dark)
        .onAppear {
            // Load initial data
            chatBotViewModel.loadInitialMessages()
            notificationViewModel.fetchNotifications()
            questionCategoriesViewModel.loadCategories()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .preferredColorScheme(.dark)
    }
} 