import SwiftUI

struct ChatBotView: View {
    @StateObject private var viewModel = ChatBotViewModel()
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat messages
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.messages) { message in
                            ChatBubble(message: message, isLoading: false)
                                .id(message.id)
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                MascotAvatar(emotion: .thinking, size: 32)
                                    .padding(.leading)
                                
                                LoadingBubble()
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .id("loader")
                        }
                    }
                    .padding(.vertical)
                }
                .onChange(of: viewModel.messages.count) { oldValue, newValue in
                    withAnimation {
                        scrollView.scrollTo(viewModel.messages.last?.id ?? "loader", anchor: .bottom)
                    }
                }
            }
            
            // Message input
            HStack(spacing: 12) {
                TextField("Type your question...", text: $viewModel.inputText)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .focused($isInputFocused)
                
                Button(action: {
                    isInputFocused = false
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.blue)
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isLoading)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemBackground).opacity(0.95))
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("F1 Monk Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.messages.isEmpty {
                viewModel.loadInitialMessages()
            }
        }
    }
}

struct ChatBotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView()
            .padding()
            .previewLayout(.sizeThatFits)
            .frame(height: 600)
    }
} 
