import 'package:flutter/material.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';

class WatchlistBottomSheet extends StatelessWidget {
  final List<WatchlistEntity> watchlists;
  final Function(WatchlistEntity) onSelectWatchlist;
  final VoidCallback onCreateNew;
  final Function(WatchlistEntity) onDeleteWatchlist;
  final Function(WatchlistEntity) onEditWatchlist;

  const WatchlistBottomSheet({
    super.key,
    required this.watchlists,
    required this.onSelectWatchlist,
    required this.onCreateNew,
    required this.onDeleteWatchlist,
    required this.onEditWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Section (centered)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Expanded text to center it
                 Expanded(
                  child: Text(
                    'All Watchlist',
                    textAlign: TextAlign.center,
                    style: AppStyles.h3.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                // The close button remains on the right
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Divider(color: Colors.grey, thickness: 0.4),
          ),
          // List remains as is
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: watchlists.length,
              itemBuilder: (context, index) {
                final watchlist = watchlists[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    watchlist.name,
                    style: AppStyles.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: AppColors.primary),
                    onPressed: () => onEditWatchlist(watchlist),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onSelectWatchlist(watchlist);
                  },
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Divider(color: Colors.grey, thickness: 0.4),
          ),
          // Footer Section (centered)
          Center(
            child: IntrinsicWidth(
              child: ListTile(
                leading: Icon(
                  Icons.add_circle,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Create a new watchlist',
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onCreateNew();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
