import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/result.dart';
import '../models/book_search_result_model.dart';

abstract class BookRemoteDataSource {
  Future<Result<BookSearchResultModel>> searchBooks({
    required String query,
    int startIndex = 0,
    int maxResults = 10,
  });
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final ApiClient _apiClient;

  BookRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<BookSearchResultModel>> searchBooks({
    required String query,
    int startIndex = 0,
    int maxResults = 10,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.searchEndpoint,
        queryParameters: {
          ApiConstants.queryParam: query,
          ApiConstants.startIndexParam: startIndex,
          ApiConstants.maxResultsParam: maxResults,
          ApiConstants.orderByParam: ApiConstants.defaultOrderBy,
          ApiConstants.printTypeParam: ApiConstants.defaultPrintType,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final result = BookSearchResultModel.fromJson(data);
        return Success(result);
      } else {
        return ResultFailure(
          ServerFailure(
            message: 'Failed to fetch books: ${response.statusMessage}',
            statusCode: response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return const ResultFailure(
          NetworkFailure(message: 'Connection timeout. Please check your internet connection.'),
        );
      } else if (e.type == DioExceptionType.connectionError) {
        return const ResultFailure(
          NetworkFailure(message: 'No internet connection. Please check your network.'),
        );
      } else {
        return ResultFailure(
          ServerFailure(
            message: 'Server error: ${e.message}',
            statusCode: e.response?.statusCode,
          ),
        );
      }
    } catch (e) {
      return ResultFailure(
        UnknownFailure(message: 'Unexpected error: $e'),
      );
    }
  }
}
