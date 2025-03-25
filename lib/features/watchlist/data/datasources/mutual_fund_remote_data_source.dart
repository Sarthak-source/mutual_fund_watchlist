import 'package:mutual_fund_watchlist/features/watchlist/data/models/mutual_fund_model.dart';

export 'mutual_fund_remote_data_source_impl.dart';

abstract class MutualFundRemoteDataSource {
  Future<List<MutualFundModel>> getMutualFundsList();
  Future<MutualFundModel> getMutualFundProfile(String isin);
  Future<List<MutualFundModel>> getMockMutualFundsList();
} 