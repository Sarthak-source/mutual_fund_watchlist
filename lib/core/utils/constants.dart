/// App-wide constants used throughout the application
class AppConstants {
  // App Info
  static const String appName = 'Mutual Fund Watchlist';
  static const String appVersion = '1.0.0';
  
  // Screen Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  
  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusExtraLarge = 24.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // API Related
  static const int timeoutDuration = 30; // in seconds
  
  // Shared Preferences Keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
}
