import 'package:dio/dio.dart';
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
import 'package:mutual_fund_watchlist/features/watchlist/data/datasources/mutual_fund_remote_data_source.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/repositories/mutual_fund_repository_impl.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/repositories/mutual_fund_repository.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/usecases/delete_watchlist.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/usecases/get_mutual_funds_list_usecase.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/usecases/get_watchlists.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/usecases/save_watchlist.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/cubit/watchlist_cubit.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/pages/watchlist_page.dart';
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
    GoRoute(
      path: '/watchlist',
      name: 'watchlist',
      builder: (context, state) => const WatchlistPage(),
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

  // Watchlist dependencies
  sl.registerLazySingleton(() => Dio());
  
  sl.registerLazySingleton<MutualFundRemoteDataSource>(
    () => MutualFundRemoteDataSourceImpl(
      dio: sl<Dio>(),
      apiKey: 'cvgedrhr01qqg993v2i0cvgedrhr01qqg993v2ig', // Replace with your actual API key or use environment variable
    )
  );
  
  sl.registerLazySingleton<MutualFundRepository>(
    () => MutualFundRepositoryImpl(
      remoteDataSource: sl<MutualFundRemoteDataSource>(),
    )
  );
  
  // Initialize Hive and register WatchlistLocalDataSource
  sl.registerSingletonAsync<WatchlistLocalDataSource>(() async {
    return await WatchlistLocalDataSourceImpl.init();
  });
  
  // Register WatchlistRepository
  sl.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(sl.get<WatchlistLocalDataSource>())
  );
  
  sl.registerLazySingleton(() => GetMutualFundsListUseCase(sl<MutualFundRepository>()));
  
  // Register new watchlist use cases
  sl.registerLazySingleton(() => GetWatchlists(sl<WatchlistRepository>()));
  sl.registerLazySingleton(() => SaveWatchlist(sl<WatchlistRepository>()));
  sl.registerLazySingleton(() => DeleteWatchlist(sl<WatchlistRepository>()));

  sl.registerFactory(() => WatchlistCubit(
    getWatchlists: sl<GetWatchlists>(),
    saveWatchlist: sl<SaveWatchlist>(),
    deleteWatchlist: sl<DeleteWatchlist>(),
  ));
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
  
  // Wait for async dependencies to initialize
  await sl.allReady();
  
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
        BlocProvider<WatchlistCubit>(
          create: (context) => sl<WatchlistCubit>(),
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

