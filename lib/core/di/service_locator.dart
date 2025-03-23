import 'package:get_it/get_it.dart';
import 'package:mutual_fund_watchlist/features/authflow/data/datasources/auth_remote_data_source.dart';
import 'package:mutual_fund_watchlist/features/authflow/data/repositories/auth_repository_impl.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/repositories/auth_repository.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/get_current_user_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/is_authenticated_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/register_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/sign_in_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/sign_in_with_mobile_otp_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/sign_out_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/domain/usecases/verify_otp_usecase.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

/// Initialize all dependencies for the application
Future<void> initServiceLocator() async {
  // Initialize external dependencies
  final supabase = Supabase.instance.client;
  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase);

  // Data sources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator<SupabaseClient>(),
    ),
  );

  // Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    ),
  );

  // Use cases
  serviceLocator.registerLazySingleton(
    () => SignInUseCase(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => RegisterUseCase(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => SignOutUseCase(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => GetCurrentUserUseCase(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => IsAuthenticatedUseCase(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => SignInWithMobileOTPUseCase(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerLazySingleton(
    () => VerifyOTPUseCase(serviceLocator<AuthRepository>()),
  );

  // Cubits
  serviceLocator.registerFactory(
    () => AuthCubit(
      signInWithMobileOTPUseCase: serviceLocator<SignInWithMobileOTPUseCase>(),
      verifyOTPUseCase: serviceLocator<VerifyOTPUseCase>(),
      signOutUseCase: serviceLocator<SignOutUseCase>(),
      getCurrentUserUseCase: serviceLocator<GetCurrentUserUseCase>(),
      isAuthenticatedUseCase: serviceLocator<IsAuthenticatedUseCase>(),
    ),
  );
} 