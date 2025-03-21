import SwiftUI

struct LaunchScreen: View {
    @State private var isAnimating = false
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // App Logo
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .fill(Color.blue.opacity(0.4))
                        .frame(width: 90, height: 90)
                    
                    Image(systemName: "airplane.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.easeInOut(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
                
                // App Name
                Text("F1 Monk")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(
                        Animation.easeIn(duration: 1.2)
                            .delay(0.4),
                        value: isAnimating
                    )
                
                // Tagline
                Text("Your enlightened guide to F1 visa success")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(
                        Animation.easeIn(duration: 1.2)
                            .delay(0.8),
                        value: isAnimating
                    )
                
                // Loading indicator
                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                    
                    Text("Loading your resources...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .opacity(isAnimating ? 1 : 0)
                .animation(
                    Animation.easeIn(duration: 1)
                        .delay(1.2),
                    value: isAnimating
                )
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            isAnimating = true
            
            // Simulate loading time and then show main app
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                showMainApp = true
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainTabView()
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
            .preferredColorScheme(.dark)
    }
} 