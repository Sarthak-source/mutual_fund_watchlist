# Mutual Fund Watchlist - Authentication Flow with Go Router

This project demonstrates a clean architecture implementation of an authentication flow using Flutter with the following features:

- Clean Architecture with Domain, Data, and Presentation layers
- BLoC pattern using Flutter Bloc for state management
- Go Router for navigation and deep linking support
- Dependency Injection with GetIt

## Project Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── routes/
│   │   └── app_router.dart
│   └── usecases/
│       └── usecase.dart
└── features/
    └── authflow/
        ├── data/
        │   ├── datasources/
        │   │   └── auth_remote_data_source.dart
        │   ├── models/
        │   │   └── user_model.dart
        │   └── repositories/
        │       └── auth_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── user.dart
        │   ├── repositories/
        │   │   └── auth_repository.dart
        │   └── usecases/
        │       ├── sign_in_usecase.dart
        │       └── verify_otp_usecase.dart
        └── presentation/
            ├── cubit/
            │   ├── auth_cubit.dart
            │   └── auth_state.dart
            └── pages/
                ├── welcome_screen.dart
                ├── sign_in_screen.dart
                └── sign_in_otp_screen.dart
```

## Authentication Flow

The authentication flow in this application follows these steps:

1. **Welcome Screen**: Entry point for users
2. **Sign In Screen**: Users enter their phone number
3. **OTP Screen**: Users verify the OTP sent to their phone
4. **Home Screen**: Users access the main app after successful authentication

## Navigation

This project uses Go Router for navigation. Key features include:

- Named routes for easy navigation
- Route parameters for passing data between screens
- Redirection logic based on authentication state

Example of navigating with Go Router:

```dart
// Navigate to a named route
context.goNamed('signIn');

// Navigate with parameters
context.goNamed(
  'signInOtp',
  pathParameters: {'phoneNumber': phoneNumber},
);
```

## Clean Architecture

The project follows Clean Architecture principles:

- **Domain Layer**: Contains business logic, entities, repository interfaces, and use cases
- **Data Layer**: Implements repositories, manages data sources, and models
- **Presentation Layer**: Handles UI components and state management with Bloc/Cubit

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run the app with `flutter run`

## Dependencies

- flutter_bloc: For state management
- go_router: For navigation
- get_it: For dependency injection
- dartz: For functional programming and error handling
- equatable: For value equality
