# Routing in Mutual Fund Watchlist

This project uses `go_router` for navigation, which provides a declarative and type-safe approach to routing in Flutter applications.

## Router Structure

### Basic Setup

The router is defined in `app_router.dart` and configured with several routes:

```dart
static final GoRouter router = GoRouter(
  routes: [
    // Welcome screen
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    
    // Sign In screen
    GoRoute(
      path: '/sign-in',
      name: 'signIn',
      builder: (context, state) => const SignInScreen(),
    ),
    
    // Other routes...
  ],
);
```

### Route Parameters

Routes that require parameters (like the OTP verification screen) are defined with path parameters:

```dart
GoRoute(
  path: '/sign-in/otp/:phoneNumber',
  name: 'signInOtp',
  builder: (context, state) {
    final phoneNumber = state.pathParameters['phoneNumber'] ?? '';
    return SignInOtpScreen(phoneNumber: phoneNumber);
  },
),
```

## Using the Router

### Navigation

Instead of using the traditional Navigator API, we use the extensions provided by go_router:

```dart
// Navigate to a named route
context.goNamed('signIn');

// Navigate to a route with parameters
context.goNamed(
  'signInOtp',
  pathParameters: {'phoneNumber': phoneNumber},
);
```

### Benefits of Using go_router

1. **Type Safety**: Parameter types are checked at compile time.
2. **Simplicity**: Declarative API makes routes more maintainable.
3. **Deep Linking**: Better support for deep linking and web URLs.
4. **State Preservation**: Works well with Flutter's navigation and state preservation mechanisms.

## Authentication Flow

The current implementation uses go_router to navigate through the authentication flow:

1. Welcome Screen -> Sign In Screen
2. Sign In Screen -> OTP Verification Screen (with phone number)
3. OTP Verification Screen -> Home Screen (upon successful verification)

### Further Improvements

For production apps, consider implementing additional features:

1. **Route Guards**: Add authentication checks before accessing protected routes.
2. **Redirect Logic**: Implement redirects based on auth state.
3. **Nested Routes**: Organize routes hierarchically for better structure. 