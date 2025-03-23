import 'package:flutter/material.dart';

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
          _buildNavItem(0, 'Home', Icons.home_outlined, Icons.home),
          _buildNavItem(1, 'Charts', Icons.bar_chart_outlined, Icons.bar_chart),
          _buildNavItem(2, 'Watchlist', Icons.bookmark_border_outlined, Icons.bookmark),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String label,
    IconData icon,
    IconData activeIcon,
  ) {
    final isSelected = currentIndex == index;
    
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? Colors.blue : Colors.grey,
            size: 24,
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