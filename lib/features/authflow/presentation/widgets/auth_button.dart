import 'package:flutter/material.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/theme/auth_theme.dart';

/// A reusable button for authentication screens
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final ButtonType type;
  final IconData? icon;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: AuthTheme.primaryButtonStyle,
          child: _buildButtonContent(),
        );
      case ButtonType.secondary:
        return TextButton(
          onPressed: onPressed,
          style: AuthTheme.secondaryButtonStyle,
          child: _buildButtonContent(),
        );
      case ButtonType.circle:
        return ElevatedButton(
          onPressed: onPressed,
          style: AuthTheme.circleButtonStyle,
          child: Icon(icon ?? Icons.arrow_forward),
        );
    }
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    return Text(text);
  }
}

/// Button type enum
enum ButtonType {
  primary,
  secondary,
  circle,
} 