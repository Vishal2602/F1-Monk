import SwiftUI

enum MascotEmotion: String, CaseIterable {
    case neutral
    case happy
    case thinking
    case confused
    case surprised
    case sad
    case wink
}

struct MascotAvatar: View {
    var emotion: MascotEmotion
    var size: CGFloat = 40
    
    // Animation and interaction states
    @State private var isBlinking = false
    @State private var isPressed = false
    @State private var blinkTimer: Timer? = nil
    @State private var animationAmount = 0.0
    
    // Custom color for the mascot
    @State private var colorScheme: Color = .blue
    
    var body: some View {
        ZStack {
            // Face background with enhanced gradient and effects
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [colorScheme, colorScheme.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    // Inner highlight for more dimension
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: size * 0.05)
                        .scaleEffect(0.85)
                        .blur(radius: 2)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .frame(width: size, height: size)
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            
            // Face features
            ZStack {
                // Eyes
                HStack(spacing: size * 0.25) {
                    Eye(isBlinking: isBlinking, isWinking: emotion == .wink && !isBlinking)
                        .frame(width: size * 0.2, height: size * 0.2)
                    
                    Eye(isBlinking: isBlinking)
                        .frame(width: size * 0.2, height: size * 0.2)
                }
                .offset(y: -size * 0.05)
                .offset(y: eyeOffset)
                .animation(.easeInOut(duration: 0.3), value: emotion)
                
                // Eyebrows
                HStack(spacing: size * 0.35) {
                    Eyebrow(emotion: emotion, isLeft: true)
                        .frame(width: size * 0.2, height: size * 0.05)
                        .rotationEffect(leftEyebrowRotation)
                    
                    Eyebrow(emotion: emotion, isLeft: false)
                        .frame(width: size * 0.2, height: size * 0.05)
                        .rotationEffect(rightEyebrowRotation)
                }
                .offset(y: -size * 0.2)
                .offset(y: eyebrowOffset)
                .animation(.easeInOut(duration: 0.3), value: emotion)
                
                // Mouth
                mouth
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: size * 0.5, height: size * 0.2)
                    .offset(y: size * 0.15)
                    .animation(.easeInOut(duration: 0.3), value: emotion)
            }
            
            // Animation effect for surprised emotion
            if emotion == .surprised {
                Circle()
                    .stroke(Color.white.opacity(0.5), lineWidth: 3)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        .easeOut(duration: 1)
                        .repeatForever(autoreverses: false),
                        value: animationAmount
                    )
            }
        }
        .onAppear {
            startBlinking()
            
            // Initialize animation value for surprised state
            if emotion == .surprised {
                animationAmount = 1
            }
            
            // Use professional colors
            let professionalColors: [Color] = [
                Color(red: 0.4, green: 0.3, blue: 0.8), // Purple
                Color(red: 0.3, green: 0.6, blue: 0.9), // Blue
                Color(red: 0.5, green: 0.3, blue: 0.7), // Lavender
                Color(red: 0.2, green: 0.5, blue: 0.8)  // Royal Blue
            ]
            colorScheme = professionalColors.randomElement() ?? .blue
        }
        .onDisappear {
            blinkTimer?.invalidate()
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
    
    // MARK: - Facial Feature Properties
    
    private var eyeOffset: CGFloat {
        switch emotion {
        case .neutral:
            return 0
        case .happy, .wink:
            return 2
        case .thinking:
            return -2
        case .confused:
            return 0
        case .surprised:
            return -3
        case .sad:
            return 2
        }
    }
    
    private var eyebrowOffset: CGFloat {
        switch emotion {
        case .neutral:
            return 0
        case .happy, .wink:
            return -2
        case .thinking:
            return -4
        case .confused:
            return 0
        case .surprised:
            return -6
        case .sad:
            return 2
        }
    }
    
    private var leftEyebrowRotation: Angle {
        switch emotion {
        case .confused:
            return .degrees(15)
        case .sad:
            return .degrees(-15)
        case .surprised:
            return .degrees(-10)
        default:
            return .degrees(0)
        }
    }
    
    private var rightEyebrowRotation: Angle {
        switch emotion {
        case .confused:
            return .degrees(-15)
        case .sad:
            return .degrees(15)
        case .surprised:
            return .degrees(10)
        default:
            return .degrees(0)
        }
    }
    
    private var mouth: Path {
        Path { path in
            switch emotion {
            case .neutral:
                // Slightly curved neutral mouth for friendlier appearance
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: 0),
                    control: CGPoint(x: size * 0.25, y: size * 0.02)
                )
            case .happy, .wink:
                // Bigger, more pronounced smile
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: 0),
                    control: CGPoint(x: size * 0.25, y: size * 0.2)
                )
                
                // Add a small inner line for the smile for more detail
                path.move(to: CGPoint(x: size * 0.1, y: size * 0.05))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.4, y: size * 0.05),
                    control: CGPoint(x: size * 0.25, y: size * 0.15)
                )
            case .thinking:
                // Thoughtful expression
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: 0),
                    control: CGPoint(x: size * 0.25, y: -size * 0.1)
                )
                
                // Add a small dot to the side to show thinking
                let dotSize = size * 0.05
                path.addEllipse(in: CGRect(x: size * 0.5 + dotSize, y: -dotSize/2, width: dotSize, height: dotSize))
            case .confused:
                // More pronounced confused mouth
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: size * 0.1),
                    control: CGPoint(x: size * 0.25, y: -size * 0.08)
                )
            case .surprised:
                // More expressive "O" mouth for surprise
                let circleRadius = size * 0.12
                path.addEllipse(in: CGRect(x: size * 0.15, y: -circleRadius/2, width: circleRadius, height: circleRadius))
                // Add inner circle for depth
                path.addEllipse(in: CGRect(x: size * 0.17, y: -circleRadius/2 + size * 0.02, width: circleRadius - size * 0.04, height: circleRadius - size * 0.04))
            case .sad:
                // More empathetic sad expression
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.5, y: 0),
                    control: CGPoint(x: size * 0.25, y: -size * 0.18)
                )
            }
        }
    }
    
    // MARK: - Animation Functions
    
    private func startBlinking() {
        // Random blinking effect
        blinkTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 2...5), repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.1)) {
                isBlinking = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isBlinking = false
                }
            }
        }
    }
}

// MARK: - Supporting View Components

struct Eye: View {
    let isBlinking: Bool
    var isWinking: Bool = false
    
    var body: some View {
        ZStack {
            // White of eye with soft shadow for depth
            Circle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
            
            if !isWinking {
                // Pupil with more character
                Circle()
                    .fill(Color.black)
                    .scaleEffect(0.5)
                
                // Multiple eye highlights for more life-like appearance
                Circle()
                    .fill(Color.white)
                    .scaleEffect(0.2)
                    .offset(x: -1, y: -1)
                
                // Second smaller highlight
                Circle()
                    .fill(Color.white.opacity(0.7))
                    .scaleEffect(0.1)
                    .offset(x: 1, y: 1)
            }
        }
        .scaleEffect(y: isBlinking || isWinking ? 0.1 : 1)
        // Add a subtle scaling animation to make the eyes feel more alive
        .animation(.easeInOut(duration: 0.2), value: isBlinking)
    }
}

struct Eyebrow: View {
    let emotion: MascotEmotion
    let isLeft: Bool
    
    var body: some View {
        Capsule()
            .fill(Color.white)
            .scaleEffect(x: eyebrowWidth)
    }
    
    private var eyebrowWidth: CGFloat {
        if isLeft && emotion == .confused || !isLeft && emotion == .thinking {
            return 0.8
        } else if emotion == .surprised {
            return 1.2
        } else {
            return 1.0
        }
    }
}

// MARK: - Preview

struct MascotAvatar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MascotAvatar(emotion: .neutral, size: 100)
            MascotAvatar(emotion: .happy, size: 100)
            MascotAvatar(emotion: .thinking, size: 100)
            MascotAvatar(emotion: .confused, size: 100)
            MascotAvatar(emotion: .surprised, size: 100)
            MascotAvatar(emotion: .sad, size: 100)
            MascotAvatar(emotion: .wink, size: 100)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .previewLayout(.sizeThatFits)
    }
}
