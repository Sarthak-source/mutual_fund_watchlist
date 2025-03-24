import 'package:flutter/material.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';

class WatchlistBottomSheet extends StatelessWidget {
  final List<WatchlistEntity> watchlists;
  final Function(WatchlistEntity) onSelectWatchlist;
  final VoidCallback onCreateNew;

  const WatchlistBottomSheet({
    Key? key,
    required this.watchlists,
    required this.onSelectWatchlist,
    required this.onCreateNew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Watchlist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: watchlists.length,
              itemBuilder: (context, index) {
                final watchlist = watchlists[index];
                return ListTile(
                  title: Text(
                    watchlist.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onSelectWatchlist(watchlist);
                  },
                );
              },
            ),
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(
              Icons.add_circle,
              color: Colors.blue,
            ),
            title: const Text(
              'Create a new watchlist',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.pop(context);
              onCreateNew();
            },
          ),
        ],
      ),
    );
  }
} 