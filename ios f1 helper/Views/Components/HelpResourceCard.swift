import SwiftUI

struct HelpResourceCard: View {
    let resource: HelpResource
    
    var body: some View {
        Button(action: {
            if let url = URL(string: resource.url) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: resource.icon)
                        .font(.system(size: 22))
                        .foregroundColor(.blue)
                }
                
                // Title
                Text(resource.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                // Content
                Text(resource.content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                Spacer()
                
                // Link indicator
                HStack {
                    Spacer()
                    
                    Image(systemName: "arrow.right.circle")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
        }
    }
}

struct HelpResourceCard_Previews: PreviewProvider {
    static var previews: some View {
        HelpResourceCard(resource: HelpResource(
            title: "F1 Visa Resources",
            icon: "doc.text",
            content: "Access official USCIS documents, visa application guides, and student resources.",
            url: "https://www.uscis.gov"
        ))
        .frame(width: 170, height: 180)
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
} 