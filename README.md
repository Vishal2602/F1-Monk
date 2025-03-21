# F1 Monk

Your enlightened guide to F1 visa success - a comprehensive iOS application designed to provide wisdom and guidance for international students navigating the F1 visa process.

## About

F1 Monk is a powerful mobile companion for international students in the United States. Built with a focus on user experience and accurate information, the app helps students maintain their F1 status, understand complex visa regulations, plan for important deadlines, and get answers to their most pressing questions.

## Features

- **AI-Powered Chat Assistant**: Get enlightened answers to your F1 visa-related questions with context-aware responses tailored to your specific situation
- **Personalized Timeline**: Track important dates and deadlines specific to your F1 journey
- **Question Categories**: Browse through organized categories of common F1 visa questions
- **Notifications**: Stay updated with important visa deadlines and requirements
- **User Profile**: Store your academic and visa information for personalized guidance
- **Help Center**: Access comprehensive guides and resources about F1 visa regulations

## Screenshots

*Screenshots will be added here once the app is fully developed*

## Technical Stack

- **Frontend**: SwiftUI for modern, responsive iOS UI
- **Architecture**: MVVM (Model-View-ViewModel) pattern
- **AI Integration**: Custom NLP engine with xAI/Grok API and Google Dialogflow
- **State Management**: Combine framework for reactive programming

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/F1Monk.git
   cd F1Monk
   ```

2. Set up environment variables
   - Copy the `.env.example` file to `.env`
   - Fill in your API keys and configuration values (see Environment Setup below)

3. Open `ios f1 helper.xcodeproj` in Xcode

4. Build and run the app on your device or simulator

## Environment Setup

This project requires configuration of several environment variables to enable all features:

1. Copy the example environment file to create your own:
   ```bash
   cp .env.example .env
   ```

2. Edit the `.env` file and add the following:
   - **xAI/Grok API Key**: For the AI chat functionality
   - **Google Cloud Project ID and Credentials**: For Dialogflow integration
   - **Database configuration** (optional): For persistent storage

Detailed instructions for obtaining each key are included in the `.env.example` file.

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures representing core entities like messages, notifications, and question categories
- **Views**: SwiftUI views for displaying the user interface
- **ViewModels**: Classes that manage the business logic and data for the views
- **Services**: Components for networking, data persistence, and other utilities

### Key Components

- **ChatService**: Handles communication with AI backends to provide visa guidance
- **ProfileViewModel**: Manages user profile data and personalizes the experience
- **NotificationViewModel**: Handles important alerts and deadlines
- **MainTabView**: Coordinates navigation between the app's main sections

## Dependencies

The app uses the following frameworks and libraries:

- SwiftUI for the user interface
- Combine for reactive programming
- URLSession for networking

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the Apache License, Version 2.0. See the LICENSE file for details.

## Acknowledgments

- Special thanks to all international student advisors who provided expertise
- Icons from SF Symbols
- Design inspiration from Apple Human Interface Guidelines 