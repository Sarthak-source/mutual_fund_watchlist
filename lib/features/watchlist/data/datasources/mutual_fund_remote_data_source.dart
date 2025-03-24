import 'package:dio/dio.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/models/mutual_fund_model.dart';

abstract class MutualFundRemoteDataSource {
  Future<List<MutualFundModel>> getMutualFundsList();
  Future<MutualFundModel> getMutualFundProfile(String isin);
  Future<List<MutualFundModel>> getMockMutualFundsList();
}

class MutualFundRemoteDataSourceImpl implements MutualFundRemoteDataSource {
  final Dio dio;
  final String apiKey;

  MutualFundRemoteDataSourceImpl({
    required this.dio,
    required this.apiKey,
  });

  @override
  Future<List<MutualFundModel>> getMutualFundsList() async {
    try {
      final url = 'https://finnhub.io/api/v1/mutual-fund/list?token=$apiKey';
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((json) => MutualFundModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load mutual funds list: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load mutual funds list: $e');
    }
  }

  @override
  Future<MutualFundModel> getMutualFundProfile(String isin) async {
    try {
      final url = 'https://finnhub.io/api/v1/mutual-fund/profile?isin=$isin&token=$apiKey';
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return MutualFundModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load mutual fund profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load mutual fund profile: $e');
    }
  }

  // Mock data for testing without API key
  @override
  Future<List<MutualFundModel>> getMockMutualFundsList() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    return [
      const MutualFundModel(
        isin: 'INF209K01025',
        name: 'HDFC Top 100 Fund',
        category: 'Equity - Large Cap',
        nav: 892.35,
        oneYearReturn: 12.5,
        threeYearReturn: 15.2,
        fiveYearReturn: 13.8,
        amc: 'HDFC Mutual Fund',
        symbol: 'HDFC100',
        currentPrice: 892.35,
        changePercent: 1.2,
        netAssetValue: 892.35,
        ytdReturn: 8.7,
      ),
      const MutualFundModel(
        isin: 'INF090I01239',
        name: 'Axis Bluechip Fund',
        category: 'Equity - Large Cap',
        nav: 45.67,
        oneYearReturn: 10.2,
        threeYearReturn: 14.1,
        fiveYearReturn: 12.9,
        amc: 'Axis Mutual Fund',
        symbol: 'AXISBCHIP',
        currentPrice: 45.67,
        changePercent: -0.3,
        netAssetValue: 45.67,
        ytdReturn: 6.4,
      ),
      const MutualFundModel(
        isin: 'INF179K01BE2',
        name: 'ICICI Prudential Value Discovery Fund',
        category: 'Equity - Value',
        nav: 235.12,
        oneYearReturn: 15.7,
        threeYearReturn: 18.3,
        fiveYearReturn: 14.2,
        amc: 'ICICI Prudential Mutual Fund',
        symbol: 'ICICIVDIS',
        currentPrice: 235.12,
        changePercent: 0.8,
        netAssetValue: 235.12,
        ytdReturn: 11.3,
      ),
      const MutualFundModel(
        isin: 'INF846K01131',
        name: 'SBI Small Cap Fund',
        category: 'Equity - Small Cap',
        nav: 78.45,
        oneYearReturn: 25.3,
        threeYearReturn: 22.7,
        fiveYearReturn: 19.8,
        amc: 'SBI Mutual Fund',
        symbol: 'SBISMLCAP',
        currentPrice: 78.45,
        changePercent: 2.1,
        netAssetValue: 78.45,
        ytdReturn: 17.9,
      ),
      const MutualFundModel(
        isin: 'INF740K01185',
        name: 'Mirae Asset Tax Saver Fund',
        category: 'Equity - ELSS',
        nav: 32.89,
        oneYearReturn: 14.9,
        threeYearReturn: 16.5,
        fiveYearReturn: 15.3,
        amc: 'Mirae Asset Mutual Fund',
        symbol: 'MIRAETAX',
        currentPrice: 32.89,
        changePercent: 0.6,
        netAssetValue: 32.89,
        ytdReturn: 9.8,
      ),
    ];
  }
} 