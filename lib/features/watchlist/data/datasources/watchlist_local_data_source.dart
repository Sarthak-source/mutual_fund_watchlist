import 'dart:convert';

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
  late final Box<String> _watchlistBox;
  static const String boxName = 'watchlists';

  WatchlistLocalDataSourceImpl(this._watchlistBox);

  static Future<WatchlistLocalDataSourceImpl> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>(boxName);
    return WatchlistLocalDataSourceImpl(box);
  }

  @override
  Future<List<WatchlistModel>> getWatchlists() async {
    try {
      return _watchlistBox.values.map((jsonString) {
        final map = Map<String, dynamic>.from(
          jsonDecode(jsonString) as Map
        );
        return WatchlistModel.fromJson(map);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get watchlists: $e');
    }
  }

  @override
  Future<WatchlistModel> getWatchlistById(String id) async {
    try {
      final jsonString = _watchlistBox.get(id);
      if (jsonString == null) {
        throw Exception('Watchlist not found');
      }
      
      final map = Map<String, dynamic>.from(
        jsonDecode(jsonString) as Map
      );
      return WatchlistModel.fromJson(map);
    } catch (e) {
      throw Exception('Failed to get watchlist: $e');
    }
  }

  @override
  Future<void> saveWatchlist(WatchlistModel watchlist) async {
    final jsonString = jsonEncode(watchlist.toJson());
    await _watchlistBox.put(watchlist.id, jsonString);
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