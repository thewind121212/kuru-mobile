import 'package:kuru_mobile/core/network/api_exception.dart';

sealed class ApiResult<T> {
  const ApiResult();
  factory ApiResult.success(T data) = ApiSuccess<T>;
  factory ApiResult.failure(ApiException err) = ApiFailure<T>;
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);
  final T data;
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.err);
  final ApiException err;
}

extension ApiResultX<T> on Future<ApiResult<T>> {
  /// Returns the value on success, throws the typed exception on failure.
  /// Use inside Riverpod async notifiers where throwing routes to AsyncError.
  Future<T> unwrap() async {
    final r = await this;
    return switch (r) {
      ApiSuccess<T>(:final data) => data,
      ApiFailure<T>(:final err) => throw err,
    };
  }
}
