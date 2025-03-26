import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/cubit/watchlist_cubit.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/widgets/mutual_fund_search_card.dart';

class EmptyWatchlist extends StatefulWidget {
  final int tabIndex;
  const EmptyWatchlist({
    super.key,
    required this.tabIndex,
  });

  @override
  State<EmptyWatchlist> createState() => _EmptyWatchlistState();
}

class _EmptyWatchlistState extends State<EmptyWatchlist> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<MutualFundEntity> _searchResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchResults = [];
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    final results = await context.read<WatchlistCubit>().searchFunds(query);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSearching) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search for Mutual Funds, AMC, Fund Managers...',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon:
                    const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: _toggleSearch,
                ),
                filled: true,
                fillColor: AppColors.cardBackground,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8), // reduced vertical padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                _performSearch(query);
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _searchResults.isEmpty && _searchController.text.isNotEmpty
                    ? Center(
                        child: Text(
                          'No mutual funds found',
                          style: AppStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final fund = _searchResults[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: MutualFundSearchCard(
                              fund: fund,
                              isSelected: false,
                              onToggle: () {
                                context
                                    .read<WatchlistCubit>()
                                    .addFundToWatchlist(
                                      fund,
                                      tabIndex: widget.tabIndex,
                                    );
                                _toggleSearch(); // Close search after adding
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SVG image for watchlist icon
          SizedBox(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.asset(
              'assets/watch-list.svg',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          // Main title text
          Text(
            'Looks like your watchlist is empty',
            style: AppStyles.bodyMedium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Subtitle text
          Text(
            'Add mutual funds to your watchlist to track them',
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Outlined button styled with consistent colors and font
          OutlinedButton(
            onPressed: _toggleSearch,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: AppColors.textPrimary,
                width: 0.4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                Text(
                  'Add Mutual Funds',
                  style: AppStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
