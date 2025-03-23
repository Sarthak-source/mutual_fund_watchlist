import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mutual_fund_watchlist/features/onboarding/domain/entities/user.dart';
import 'package:mutual_fund_watchlist/features/onboarding/domain/usecases/get_current_user_usecase.dart';
import 'package:mutual_fund_watchlist/features/onboarding/presentation/cubit/onboarding_state.dart';

/// Cubit for managing onboarding and navigation operations
class OnboardingCubit extends Cubit<OnboardingState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  
  OnboardingCubit({
    required this.getCurrentUserUseCase,
  }) : super(const OnboardingState());

  /// Current user data
  User? _currentUser;
  User? get currentUser => _currentUser;

  /// Change the current tab
  void changeTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  /// Initialize the dashboard data
  Future<void> initializeDashboard() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      // Get user profile data
      await fetchUserProfile();
      
      // Add more dashboard data initialization as needed
      await Future.delayed(const Duration(milliseconds: 200));
      
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  /// Fetch user profile data
  Future<void> fetchUserProfile() async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      
      // Get user data from repository
      _currentUser = await getCurrentUserUseCase.execute();
      
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
} 