# Todo Firebase Demo

## Description

Todo Firebase Demo is a Flutter application showcasing best practices and clean architecture principles for creating a simple todo app with Firebase backend integration. The app demonstrates key features including Firebase Authentication, Firestore for data storage, offline support with Isar for local caching, and state management with Riverpod.

## Features

- **Authentication**:
    - Firebase Authentication (Email/Password).
    - User registration, login, and logout functionality.

- **Data Handling**:
    - Firestore for storing and retrieving tasks.
    - Offline caching with Isar to ensure smooth access when offline.
    - Synchronization between Firestore and Isar.

- **CRUD Operations**:
    - Add, delete, and view tasks.
    - A main screen that displays a list of tasks.

- **Detail Screen & User Profile**:
    - Detail screen for task details.
    - Profile screen displaying the user's email and logout button.

- **Architecture**:
    - MVVM (Model-View-ViewModel) pattern.
    - Clean Architecture principles with domain, data, and presentation layers.

- **Testing**:
    - Basic unit tests for repositories and ViewModel logic.

## Requirements

- **Flutter Version**: `3.27.1`
- **Dart SDK**: `>=3.0.2 <4.0.0`

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/utsav-savani/todo-list-demo
   cd todo_firebase_demo
   ```

2. **Install Dependencies**:
   Run the following command to install required dependencies:
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**:
    - Create a Firebase project.
    - Add an Android and/or iOS app to the Firebase project.
    - Download the `google-services.json` (for Android) and/or `GoogleService-Info.plist` (for iOS) and place them in the respective project directories:
        - `android/app/google-services.json`
        - `ios/Runner/GoogleService-Info.plist`
    - Enable Firebase Authentication and Firestore in the Firebase console.

4. **Run the App**:
   Use the following command to start the app:
   ```bash
   flutter run
   ```

5. **Test Data**:
    - **Email**: `testtodo@yopmail.com`
    - **Password**: `TestTodo1@234`

6. **Run Unit Tests**:
    - To run all tests:
      ```bash
      fvm flutter test test/widget_test.dart
      ```
    - To test app initialization:
      ```bash
      fvm flutter test test/core/app_initialization_test.dart
      ```

7. **Preview**:
   Watch the app demo [here](https://drive.google.com/file/d/1VUh5H7YS5b5QUx05JM2U22e76i8BeFUu/view?usp=sharing).

## Notes on Used Packages

- **firebase_core**: Initializes Firebase in the app.
- **firebase_auth**: Provides Firebase Authentication support.
- **cloud_firestore**: Enables Firestore integration for real-time database functionality.
- **isar**: A high-performance database for offline caching.
- **isar_flutter_libs**: Flutter bindings for Isar.
- **flutter_riverpod**: State management for clean architecture.
- **riverpod_annotation**: Annotations for generating Riverpod providers.
- **go_router**: Navigation and routing within the app.
- **connectivity_plus**: Checks and monitors internet connectivity.
- **path_provider**: For accessing device directories.
- **intl**: Provides internationalization support.
- **get_it**: Dependency injection for easier testability.
- **mockito & mocktail**: For mocking dependencies in unit tests.
- **flutter_test**: Built-in Flutter testing package for writing and running tests.

## Folder Structure

The project is organized following Clean Architecture principles:

- **domain/**: Contains core business logic and abstract repositories.
- **data/**: Includes concrete implementations of repositories and data sources (Firestore and Isar).
- **presentation/**: Contains UI code, ViewModels, and Riverpod providers.
- **tests/**: Includes unit tests for key components.

## Author

Utsav Savani

