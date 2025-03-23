import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/cubit/auth_cubit.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/cubit/auth_state.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/pages/welcome_screen.dart';
import 'package:mutual_fund_watchlist/features/onboarding/presentation/pages/home_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  
  // Router configuration with redirection logic
  static GoRouter router({required BuildContext context}) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      
      // Define redirect logic based on auth state
      redirect: (BuildContext context, GoRouterState state) {
        final bool isAuthenticated = authCubit.state.status == AuthStatus.authenticated;
        final bool isOnWelcomePage = state.matchedLocation == '/';
        final bool isOnAuthPage = state.matchedLocation.startsWith('/login') || 
                                 state.matchedLocation.startsWith('/register');
        
        // If user is authenticated but on a welcome or auth page, redirect to home
        if (isAuthenticated && (isOnWelcomePage || isOnAuthPage)) {
          return '/home';
        }
        
        // If user is on home or protected route, but not authenticated
        final bool isOnProtectedRoute = !isOnWelcomePage && !isOnAuthPage;
        if (!isAuthenticated && isOnProtectedRoute) {
          return '/';
        }
        
        // No redirection needed
        return null;
      },
      
      routes: [
        // Welcome screen
        GoRoute(
          path: '/',
          name: 'welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        
        
        // Home screen
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
      
      // Error handling
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: Route not found!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Could not navigate to: ${state.matchedLocation}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to Welcome Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 