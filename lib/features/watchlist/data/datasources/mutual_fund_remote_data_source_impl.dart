import 'package:dio/dio.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/datasources/mutual_fund_remote_data_source.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/models/mutual_fund_model.dart';

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

  @override
  Future<List<MutualFundModel>> getMockMutualFundsList() async {
    // Return mock data for testing
    return [
      MutualFundModel(
        isin: 'INF1234567890',
        name: 'HDFC Top 100 Fund',
        category: 'Large Cap',
        nav: 45.67,
        oneYearReturn: 15.5,
        threeYearReturn: 12.3,
        fiveYearReturn: 10.8,
        description: 'A large cap equity fund',
        amc: 'HDFC Mutual Fund',
      ),
      MutualFundModel(
        isin: 'INF9876543210',
        name: 'ICICI Prudential Bluechip Fund',
        category: 'Large Cap',
        nav: 38.92,
        oneYearReturn: 14.2,
        threeYearReturn: 11.8,
        fiveYearReturn: 9.5,
        description: 'A large cap equity fund',
        amc: 'ICICI Prudential Mutual Fund',
      ),
    ];
  }
} 