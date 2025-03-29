import 'package:dio/dio.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/datasources/mutual_fund_remote_data_source.dart';
import 'package:mutual_fund_watchlist/features/watchlist/data/models/mutual_fund_model.dart';

class MutualFundRemoteDataSourceImpl implements MutualFundRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  MutualFundRemoteDataSourceImpl({
    required this.dio,
    this.baseUrl = 'https://sarthakhr-mutual-fund.hf.space',
  });

  @override
  Future<List<MutualFundModel>> getMutualFundsList() async {
    try {
      final url = '$baseUrl/api/v1/funds/';
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
      final url = '$baseUrl/api/v1/funds/$isin';
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
    // This method is kept for backward compatibility or testing purposes
    return getMutualFundsList();
  }
} 