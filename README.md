# Folder IT - Flutter Project

## Project Overview

Folder IT is a Flutter-based application designed to streamline file management and enhance collaboration within groups. It provides a user-friendly interface for organizing, sharing, and managing files, along with features for group creation, member invitation, and task assignment. With support for multiple languages and customizable themes, Folder IT offers a personalized and efficient file management experience.

## Features

*   **File Management**: Securely upload, store, and organize your files with ease.
*   **Group Collaboration**: Create and manage groups, invite members, assign roles, and foster seamless teamwork.
*   **User Authentication**: Secure login and signup functionality to protect your data and ensure authorized access.
*   **Task Management**: Assign and track tasks within groups to enhance productivity and accountability.
*   **Localization**: Supports multiple languages (English and Arabic) for a global user base.
*   **Admin Panel**: Dedicated features for administrators to efficiently manage users and files.
*   **File Sharing**: Share files seamlessly within groups, ensuring everyone has access to the necessary resources.
*   **User Logs**: Track user activity to maintain transparency and monitor application usage.
*   **Customizable Themes**: Switch between light and dark themes to personalize your experience.

## Tech Stack

*   **Flutter**: UI framework.
*   **Dart**: Programming language.
*   **flutter\_bloc**: State management.
*   **go\_router**: Navigation.
*   **http**: Networking.
*   **shared\_preferences**: Local storage.
*   **get\_it**: Service locator.
*   **image\_picker**: Image selection.
*   **flutter\_dropzone**: Drag and drop file uploads.
*   **flutter\_svg**: SVG support.
*   **pdf**: PDF support.
*   **csv**: CSV support.
*   **connectivity\_plus**: Check network connectivity.
*   **permission\_handler**: Handle permissions.
*   **intl**: Internationalization.

## Installation Instructions

1.  Ensure you have Flutter installed. If not, follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
2.  Clone this repository.
3.  Navigate to the project directory in your terminal.
4.  Run `flutter pub get` to install dependencies.

## Usage

1.  Run the application using `flutter run`.
2.  The application supports multiple platforms (Android, iOS, Web, macOS, Linux, Windows). Choose the desired platform when running the app.
3.  Login or signup to access the application's features.
4.  Create or join groups to collaborate with other users.
5.  Upload and manage files within your groups.
6.  Assign and track tasks.

## Folder Structure

*   `android/`, `ios/`, `linux/`, `macos/`, `web/`, `windows/`: Platform-specific code.
*   `lib/`: Main application code.
    *   `core/`: Core functionalities like networking, databases, and services.
    *   `features/`: Contains different features of the application, such as User, Groups, Home, and Admin.
    *   `localization/`: Localization files.
    *   `main.dart`: Entry point of the application.
*   `assets/`: Contains images, icons, and language files.

## Contributing

If you'd like to contribute to this project, please follow these guidelines:

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Make your changes and commit them with clear, descriptive messages.
4.  Submit a pull request.

## License

This project does not have a specified license.
