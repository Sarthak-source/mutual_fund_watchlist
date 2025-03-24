import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/cubit/watchlist_cubit.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/cubit/watchlist_state.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/widgets/empty_watchlist.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/widgets/mutual_fund_card.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with TickerProviderStateMixin {
  TabController? _tabController;
  int _previousLength = 0;

  @override
  void initState() {
    super.initState();
    // Load watchlists when the screen is first opened
    context.read<WatchlistCubit>().loadWatchlists();
  }

  void _updateTabController(WatchlistState state) {
    final int length = state.watchlists.isEmpty ? 1 : state.watchlists.length;
    
    // Only recreate controller if number of tabs changed
    if (_tabController == null || _previousLength != length) {
      _previousLength = length;
      
      // Dispose old controller if it exists
      _tabController?.dispose();
      
      // Create new controller
      _tabController = TabController(
        length: length,
        vsync: this,
        initialIndex: state.selectedTabIndex < length ? state.selectedTabIndex : 0,
      );
      
      // Add listener
      _tabController!.addListener(_handleTabChange);
    } else if (state.selectedTabIndex != _tabController!.index && 
               state.selectedTabIndex < _tabController!.length) {
      // Just update the index if needed
      _tabController!.animateTo(state.selectedTabIndex);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController!.indexIsChanging) {
      context.read<WatchlistCubit>().changeTab(_tabController!.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistCubit, WatchlistState>(
      listenWhen: (previous, current) => 
          previous.watchlists.length != current.watchlists.length ||
          previous.selectedTabIndex != current.selectedTabIndex,
      listener: (context, state) {
        _updateTabController(state);
      },
      builder: (context, state) {
        // Make sure tab controller is updated
        _updateTabController(state);
        
        return Scaffold(
          backgroundColor: AppColors.background,
          body: state.status == WatchlistStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : state.status == WatchlistStatus.error
                  ? Center(child: Text('Error: ${state.errorMessage}'))
                  : state.watchlists.isEmpty || _tabController == null
                      ? const EmptyWatchlist()
                      : Column(
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
                              tabs: state.watchlists.map((watchlist) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A1A1A),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFF333333),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    watchlist.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              }).toList(),
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
                        ),
          floatingActionButton: FloatingActionButton.extended(
            extendedPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
            onPressed: () => _showCreateWatchlistBottomSheet(context),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Watchlist',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFundsList(List<MutualFundEntity> funds) {
    return funds.isEmpty
        ? const EmptyWatchlist()
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: funds.length,
            itemBuilder: (context, index) {
              final fund = funds[index];
              return MutualFundCard(fund: fund);
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
            const Text(
              'Create New Watchlist',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Watchlist Name',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textSecondary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
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
                  child: const Text('Create'),
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
