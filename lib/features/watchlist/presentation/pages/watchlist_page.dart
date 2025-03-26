import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mutual_fund_watchlist/core/utils/app_colors.dart';
import 'package:mutual_fund_watchlist/core/utils/app_styles.dart';
import 'package:mutual_fund_watchlist/features/authflow/presentation/theme/auth_theme.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/mutual_fund_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/entities/watchlist_entity.dart';
import 'package:mutual_fund_watchlist/features/watchlist/domain/usecases/get_mutual_funds_list_usecase.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/cubit/watchlist_cubit.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/cubit/watchlist_state.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/widgets/empty_watchlist.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/widgets/mutual_fund_card.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/widgets/mutual_fund_search_card.dart';
import 'package:mutual_fund_watchlist/features/watchlist/presentation/widgets/watchlist_bottom_sheet.dart';

final sl = GetIt.instance;

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _previousLength = 0;
  final TextEditingController _searchController = TextEditingController();
  List<MutualFundEntity> _allFunds = [];
  List<MutualFundEntity> _filteredFunds = [];
  bool _isSearching = false;
  bool _isLoadingFunds = false;

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

  Future<void> _loadMutualFunds() async {
    if (_allFunds.isNotEmpty) return; // Already loaded

    setState(() {
      _isLoadingFunds = true;
    });

    final getMutualFundsUseCase = sl<GetMutualFundsListUseCase>();
    final result = await getMutualFundsUseCase();

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load mutual funds: ${failure.message}'),
            backgroundColor: Colors.red,
          ),
        );
      },
      (funds) {
        setState(() {
          _allFunds = funds;
          _filteredFunds = funds;
        });
      },
    );

    setState(() {
      _isLoadingFunds = false;
    });
  }

  void _filterFunds(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFunds = _allFunds;
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    setState(() {
      _filteredFunds = _allFunds.where((fund) {
        return fund.name.toLowerCase().contains(lowercaseQuery) ||
            fund.category.toLowerCase().contains(lowercaseQuery) ||
            (fund.amc != null &&
                fund.amc!.toLowerCase().contains(lowercaseQuery));
      }).toList();
    });
  }

  bool _isFundInWatchlist(MutualFundEntity fund, WatchlistState state) {
    if (state is WatchlistLoaded && _tabController != null) {
      final currentWatchlist = state.watchlists[_tabController!.index];
      return currentWatchlist.funds.any((f) => f.isin == fund.isin);
    }
    return false;
  }

  void _toggleFundInWatchlist(MutualFundEntity fund, WatchlistState state) {
    if (state is WatchlistLoaded && _tabController != null) {
      final watchlistCubit = context.read<WatchlistCubit>();
      final isInWatchlist = _isFundInWatchlist(fund, state);

      if (isInWatchlist) {
        watchlistCubit.removeFundFromWatchlist(fund);
      } else {
        watchlistCubit.addFundToWatchlist(
          fund,
          tabIndex: _tabController!.index,
        );
      }
    }
  }

  void _showEditWatchlistDialog(WatchlistEntity watchlist) {
    final TextEditingController controller =
        TextEditingController(text: watchlist.name);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Watchlist',
                  style: AppStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Watchlist Name',
                hintStyle: AppStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textSecondary),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              style: AppStyles.bodySmall.copyWith(
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
                    if (controller.text.isNotEmpty) {
                      context.read<WatchlistCubit>().updateWatchlist(
                            watchlist.copyWith(name: controller.text),
                          );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: AppStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
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

  void _showDeleteWatchlistDialog(WatchlistEntity watchlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Delete Watchlist',
          style: AppStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "${watchlist.name}"?',
          style: AppStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style:
                  AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WatchlistCubit>().removeWatchlist(watchlist.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Delete',
              style: AppStyles.bodySmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showWatchlistsBottomSheet() {
    showModalBottomSheet(
      context: context,
      //backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocBuilder<WatchlistCubit, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoaded) {
              return WatchlistBottomSheet(
                watchlists: state.watchlists,
                onSelectWatchlist: (watchlist) {
                  final index = state.watchlists.indexOf(watchlist);
                  if (_tabController != null) {
                    _tabController!.animateTo(index);
                  }
                },
                onCreateNew: () => _showCreateWatchlistBottomSheet(context),
                onDeleteWatchlist: _showDeleteWatchlistDialog,
                onEditWatchlist: _showEditWatchlistDialog,
              );
            }
            return const SizedBox();
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
      builder: (context) {
        return Padding(
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
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Create New Watchlist',
                  style: AppStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.grey, thickness: 0.4),
              ),
              // Use TextFormField with AuthTheme styling
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: controller,
                  style:
                      AppStyles.bodyMedium, // same style used in AuthTextField
                  decoration: AuthTheme.inputDecoration.copyWith(
                    hintText: 'Watchlist Name',
                    fillColor: Colors.grey[850], // Change to your desired color
                    filled: true,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Single centered "Create" button
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, child) {
                  final isEmpty = value.text.trim().isEmpty;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isEmpty
                            ? null
                            : () {
                                context
                                    .read<WatchlistCubit>()
                                    .createWatchlist(value.text.trim());
                                Navigator.pop(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEmpty
                              ? const Color.fromARGB(255, 61, 61, 61)
                              : AppColors.primary,
                          disabledBackgroundColor:
                              const Color.fromARGB(255, 78, 78, 78),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Create',
                          style: AppStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistCubit, WatchlistState>(
      listenWhen: (previous, current) {
        if (previous is WatchlistLoaded && current is WatchlistLoaded) {
          return previous.watchlists.length != current.watchlists.length;
        }
        return previous.runtimeType != current.runtimeType;
      },
      listener: (context, state) {
        _updateTabController(state);
      },
      builder: (context, state) {
        _updateTabController(state);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              if (!_isSearching) ...[
                _buildTabBar(state),
                Expanded(child: _buildBody(state)),
              ] else ...[
                Expanded(child: _buildSearchResults(state)),
              ],
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            extendedPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            onPressed: () {
              // If the current state is loaded and there are watchlists,
              // show the watchlists bottom sheet; otherwise, open create watchlist sheet.
              if (state is WatchlistLoaded && state.watchlists.isNotEmpty) {
                _showWatchlistsBottomSheet();
              } else {
                _showCreateWatchlistBottomSheet(context);
              }
            },
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
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

  Widget _buildTabBar(WatchlistState state) {
    if (state is! WatchlistLoaded || _tabController == null) {
      return const SizedBox();
    }

    return TabBar(
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
            color: isSelected ? AppColors.primary : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFF333333),
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
    );
  }

  Widget _buildBody(WatchlistState state) {
    if (state is WatchlistLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WatchlistError) {
      return Center(
          child: Text('Error: ${state.message}', style: AppStyles.bodyMedium));
    } else if (state is WatchlistEmpty || _tabController == null) {
      return EmptyWatchlist(tabIndex: _tabController?.index ?? 0);
    } else if (state is WatchlistLoaded) {
      return TabBarView(
        controller: _tabController,
        children: state.watchlists.map((watchlist) {
          return watchlist.isEmpty
              ? EmptyWatchlist(tabIndex: state.watchlists.indexOf(watchlist))
              : _buildFundsList(watchlist.funds);
        }).toList(),
      );
    }

    return const EmptyWatchlist(tabIndex: 0);
  }

  Widget _buildFundsList(List<MutualFundEntity> funds) {
    return funds.isEmpty
        ? EmptyWatchlist(tabIndex: _tabController?.index ?? 0)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () async {
                  // Load mutual funds if they haven't been loaded yet.
                  if (_allFunds.isEmpty) {
                    await _loadMutualFunds();
                  }
                  // Toggle the search state so that the search results are shown.
                  setState(() {
                    _isSearching = true;
                  });
                },
                icon: const Icon(Icons.add, color: AppColors.primary),
                label: Text(
                  'Add',
                  style: AppStyles.button.copyWith(color: AppColors.primary),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: funds.length,
                  itemBuilder: (context, index) {
                    final fund = funds[index];
                    return MutualFundCard(
                      fund: fund,
                      onDelete: () {
                        context
                            .read<WatchlistCubit>()
                            .removeFundFromWatchlist(fund);
                      },
                    );
                  },
                ),
              ),
            ],
          );
  }

  Widget _buildSearchResults(WatchlistState state) {
    return Column(
      children: [
        // Search Field similar to EmptyWatchlist
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
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _filteredFunds = _allFunds;
                  });
                },
              ),
              filled: true,
              fillColor: AppColors.cardBackground,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (query) {
              _filterFunds(query);
            },
          ),
        ),
        // Results list
        Expanded(
          child: _isLoadingFunds
              ? const Center(child: CircularProgressIndicator())
              : _filteredFunds.isEmpty && _searchController.text.isNotEmpty
                  ? Center(
                      child: Text(
                        'No mutual funds found',
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredFunds.length,
                      itemBuilder: (context, index) {
                        final fund = _filteredFunds[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: MutualFundSearchCard(
                            fund: fund,
                            isSelected: _isFundInWatchlist(fund, state),
                            onToggle: () => _toggleFundInWatchlist(fund, state),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
