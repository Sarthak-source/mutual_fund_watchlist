import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/features/authflow/data/datasources/auth_remote_data_source.dart';
import 'package:mutual_fund_watchlist/features/authflow/data/repositories/auth_repository_impl.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/repositories/auth_repository.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/get_current_user_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/is_authenticated_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/sign_in_with_mobile_otp_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/sign_out_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/verify_otp_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/cubit/auth_cubit.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/pages/sign_in_otp_screen.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/pages/sign_in_screen.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/pages/welcome_screen.dart';
import 'package:mutual_fund_watchlist/features/onboarding/data/datasources/user_remote_data_source.dart';
import 'package:mutual_fund_watchlist/features/onboarding/data/repositories/user_repository_impl.dart';
import 'package:mutual_fund_watchlist/features/onboarding/domain/repositories/user_repository.dart';
import 'package:mutual_fund_watchlist/features/onboarding/domain/usecases/get_current_user_usecase.dart' as onboarding;
import 'package:mutual_fund_watchlist/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:mutual_fund_watchlist/features/onboarding/presentation/pages/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Service locator
final GetIt sl = GetIt.instance;

// Create router configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/signIn',
      name: 'signIn',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/otp',
      name: 'otp',
      builder: (context, state) {
        final phoneNumber = state.extra as String? ?? '';
        return SignInOtpScreen(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

void setupDependencyInjection() {
  // External
  final supabase = Supabase.instance.client;
  sl.registerLazySingleton<SupabaseClient>(() => supabase);
  
  // Auth Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl<SupabaseClient>())
  );
  
  // User Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl());
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>())
  );
  
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserRemoteDataSource>())
  );

  // Auth UseCases
  sl.registerLazySingleton(
    () => SignInWithMobileOTPUseCase(sl<AuthRepository>())
  );
  
  sl.registerLazySingleton(
    () => VerifyOTPUseCase(sl<AuthRepository>())
  );
  
  sl.registerLazySingleton(
    () => SignOutUseCase(sl<AuthRepository>())
  );
  
  sl.registerLazySingleton(
    () => GetCurrentUserUseCase(sl<AuthRepository>())
  );
  
  sl.registerLazySingleton(
    () => IsAuthenticatedUseCase(sl<AuthRepository>())
  );
  
  // User UseCases
  sl.registerLazySingleton(
    () => onboarding.GetCurrentUserUseCase(sl<UserRepository>())
  );

  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      signInWithMobileOTPUseCase: sl<SignInWithMobileOTPUseCase>(),
      verifyOTPUseCase: sl<VerifyOTPUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      isAuthenticatedUseCase: sl<IsAuthenticatedUseCase>(),
    )
  );
  
  sl.registerFactory(
    () => OnboardingCubit(
      getCurrentUserUseCase: sl<onboarding.GetCurrentUserUseCase>(),
    )
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase - replace with your own credentials
  await Supabase.initialize(
    url: 'https://dcbrpvlrglpvpvnudjtf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjYnJwdmxyZ2xwdnB2bnVkanRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI3NTQ4MTksImV4cCI6MjA1ODMzMDgxOX0.3uchb5YhFgKTUAE-g78HapfNmoyvO2KVaqcGNX5CY_s',
  );
  
  // Initialize dependencies
  setupDependencyInjection();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => sl<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<OnboardingCubit>(
          create: (context) => sl<OnboardingCubit>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Mutual Fund Watchlist',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            background: AppColors.background,
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

