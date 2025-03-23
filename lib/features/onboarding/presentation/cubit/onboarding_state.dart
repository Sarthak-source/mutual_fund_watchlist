import 'package:equatable/equatable.dart';

/// Base class for onboarding states
class OnboardingState extends Equatable {
  final int selectedTabIndex;
  final bool isLoading;
  final String? errorMessage;

  const OnboardingState({
    this.selectedTabIndex = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  OnboardingState copyWith({
    int? selectedTabIndex,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OnboardingState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedTabIndex, isLoading, errorMessage];
}

/// Initial state for onboarding
class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

/// Loading state for onboarding operations
class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

/// Success state for onboarding operations
class OnboardingSuccess extends OnboardingState {
  final String message;

  const OnboardingSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Error state for onboarding operations
class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
} 