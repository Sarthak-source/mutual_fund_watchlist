import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/cubit/watchlist_cubit.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/cubit/watchlist_state.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/widgets/empty_watchlist.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/widgets/mutual_fund_card.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _previousLength = 0;

  @override
  void initState() {
    super.initState();
    // Load watchlists when the screen is first opened
    context.read<WatchlistCubit>().loadWatchlists();
  }

  void _updateTabController(WatchlistState state) {
  final int length;
  
  if (state is WatchlistLoaded) {
    length = state.watchlists.isEmpty ? 1 : state.watchlists.length;
  } else {
    length = 1;
  }

  // Only recreate controller if number of tabs changed
  if (_tabController == null || _previousLength != length) {
    _previousLength = length;

    // Dispose old controller if it exists
    _tabController?.dispose();

    // Create new controller
    _tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: 0,
    );

    // Add a listener to rebuild when the tab index changes
    _tabController!.addListener(() {
      setState(() {});
    });
  }
}


  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistCubit, WatchlistState>(
      listenWhen: (previous, current) {
        // Listen for state changes that affect the tab controller
        if (previous is WatchlistLoaded && current is WatchlistLoaded) {
          return previous.watchlists.length != current.watchlists.length;
        }
        return previous.runtimeType != current.runtimeType;
      },
      listener: (context, state) {
        _updateTabController(state);
      },
      builder: (context, state) {
        // Make sure tab controller is updated
        _updateTabController(state);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton.extended(
            extendedPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            onPressed: () => _showCreateWatchlistBottomSheet(context),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label:  Text(
              'Watchlist',
              style: AppStyles.button.copyWith(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(WatchlistState state) {
    if (state is WatchlistLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WatchlistError) {
      return Center(child: Text('Error: ${state.message}', style: AppStyles.bodyMedium));
    } else if (state is WatchlistEmpty || _tabController == null) {
      return const EmptyWatchlist();
    } else if (state is WatchlistLoaded) {
      return Column(
        children: [
          TabBar(
            tabAlignment: TabAlignment.start,
            controller: _tabController,
            isScrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            tabs: List.generate(state.watchlists.length, (index) {
              final watchlist = state.watchlists[index];
              final isSelected = index == _tabController?.index;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFF333333),
                    width: 1,
                  ),
                ),
                child: Text(
                  watchlist.name,
                  style: AppStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              );
            }),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: state.watchlists.map((watchlist) {
                return watchlist.isEmpty
                    ? const EmptyWatchlist()
                    : _buildFundsList(watchlist.funds);
              }).toList(),
            ),
          ),
        ],
      );
    }
    
    // Default fallback
    return const EmptyWatchlist();
  }

  Widget _buildFundsList(List<MutualFundEntity> funds) {
    return funds.isEmpty
        ? const EmptyWatchlist()
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: funds.length,
            itemBuilder: (context, index) {
              final fund = funds[index];
              return MutualFundCard(
                fund: fund,
                onDelete: () {
                  context.read<WatchlistCubit>().removeFundFromWatchlist(fund);
                },
              );
            },
          );
  }

  void _showCreateWatchlistBottomSheet(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create New Watchlist',
              style: AppStyles.h3.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Watchlist Name',
                hintStyle: TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textSecondary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              style: const TextStyle(
                fontFamily: AppStyles.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    final name = controller.text.trim();
                    if (name.isNotEmpty) {
                      context.read<WatchlistCubit>().createWatchlist(name);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Create',
                    style: AppStyles.button.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
