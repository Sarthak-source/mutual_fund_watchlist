import 'package:hive_flutter/hive_flutter.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/models/watchlist_model.dart';

abstract class WatchlistLocalDataSource {
  Future<List<WatchlistModel>> getWatchlists();
  Future<WatchlistModel> getWatchlistById(String id);
  Future<void> saveWatchlist(WatchlistModel watchlist);
  Future<void> deleteWatchlist(String id);
  Future<void> deleteWatchlists();
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final Box<Map> _watchlistBox;
  static const String boxName = 'watchlists';

  WatchlistLocalDataSourceImpl(this._watchlistBox);

  // Initialize Hive
  static Future<WatchlistLocalDataSourceImpl> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<Map>(boxName);
    return WatchlistLocalDataSourceImpl(box);
  }

  @override
  Future<List<WatchlistModel>> getWatchlists() async {
    return _watchlistBox.values
        .map((map) => WatchlistModel.fromJson(Map<String, dynamic>.from(map.cast<String, dynamic>())))
        .toList();
  }

  @override
  Future<WatchlistModel> getWatchlistById(String id) async {
    final Map<String, dynamic>? watchlistMap = _watchlistBox.get(id)?.cast<String, dynamic>();
    
    if (watchlistMap == null) {
      throw Exception('Watchlist not found');
    }
    
    return WatchlistModel.fromJson(watchlistMap);
  }

  @override
  Future<void> saveWatchlist(WatchlistModel watchlist) async {
    await _watchlistBox.put(watchlist.id, watchlist.toJson());
  }

  @override
  Future<void> deleteWatchlist(String id) async {
    await _watchlistBox.delete(id);
  }
  
  @override
  Future<void> deleteWatchlists() async {
    await _watchlistBox.clear();
  }
} 