import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Custom bottom navigation bar for the app
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Color(0xFF222222), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'Home', 'assets/home.svg'),
          _buildNavItem(1, 'Charts', 'assets/chat.svg'),
          _buildNavItem(2, 'Watchlist', 'assets/watchlist.svg'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String label,
    String svgPath,
  ) {
    final isSelected = currentIndex == index;
    
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isSelected ? Colors.blue : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
} 