import 'package:app_essentials/core/api/interceptor/api_interceptor_v2.dart';
import 'package:app_essentials/env/env_setup.dart';
import 'package:app_essentials/services/token_manager.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class DioBuilderResponse {
  final Dio dio;
  final Options options;

  DioBuilderResponse({required this.dio, required this.options});
}

final CacheOptions cacheOptions = CacheOptions(
  store: MemCacheStore(),
  policy: CachePolicy.refreshForceCache,
  priority: CachePriority.high,
  maxStale: const Duration(days: 30),
  allowPostMethod: true,
);

class DioBuilder {
  /// Creates a Dio instance with the provided token and options.
  ///
  /// The token is used for authorization, and the options define the base settings
  /// for the Dio instance.
  Dio _createDio(String token, bool hasAuth, Options options) {
    return Dio(
      BaseOptions(
        baseUrl: Environment.currentEnv.baseUrl,
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 15000),
        headers: _buildHeaders(hasAuth: hasAuth, token: token),
      ),
    );
  }

  /// Builds the headers for the Dio instance based on the authentication requirement.
  ///
  /// The [hasAuth] parameter indicates whether the headers should include an
  /// authorization token. If [hasAuth] is true, the [token] parameter is used
  /// to set the authorization header. The [useBearer] parameter determines
  /// whether the "Bearer" keyword should be included in the authorization header.
  Map<String, dynamic> _buildHeaders({
    bool hasAuth = false,
    String? token,
    bool useBearer = false,
  }) {
    final headers = {
      'Content-Type': 'application/json',
      if (hasAuth) 'Authorization': useBearer ? 'Bearer $token' : token,
    };
    return headers;
  }

  /// Builds a DioBuilderResponse containing a Dio instance with cache support.
  ///
  /// The [hasAuth] parameter indicates whether the Dio instance should include
  /// an authorization header. The [shouldQueue] parameter determines if requests
  /// should be queued. The Dio instance created includes cache support.
  Future<DioBuilderResponse> _buildDio({
    bool hasAuth = true,
    bool shouldQueue = false,
    bool useCache = false,
  }) async {
    final DioCacheInterceptor dioCacheManager =
        DioCacheInterceptor(options: cacheOptions);
    final Options options =
        useCache ? cacheOptions.toOptions() : _getDioOptions();
    final String token = await TokenManager().getToken();
    final Dio dio = _createDio(token, hasAuth, options);
    dio.interceptors.add(DioInterceptor(dio));
    if (useCache) {
      dio.interceptors.add(dioCacheManager);
    }
    if (shouldQueue) {
      dio.interceptors.add(QueuedInterceptor());
    }
    return DioBuilderResponse(dio: dio, options: options);
  }

  /// Builds a DioBuilderResponse containing a Dio instance with cache support.
  ///
  /// The [hasAuth] parameter indicates whether the Dio instance should include
  /// an authorization header. The [shouldQueue] parameter determines if requests
  /// should be queued. The Dio instance created includes cache support.
  Future<DioBuilderResponse> buildCachedDio({
    bool hasAuth = true,
    bool shouldQueue = false,
  }) async {
    return _buildDio(
      hasAuth: hasAuth,
      shouldQueue: shouldQueue,
      useCache: true,
    );
  }

  /// Builds a DioBuilderResponse containing a Dio instance without cache support.
  ///
  /// The [hasAuth] parameter indicates whether the Dio instance should include
  /// an authorization header. The [shouldQueue] parameter determines if requests
  /// should be queued. The Dio instance created does not include cache support.
  Future<DioBuilderResponse> buildNonCachedDio({
    bool hasAuth = false,
    bool shouldQueue = false,
  }) async {
    return _buildDio(
      hasAuth: hasAuth,
      shouldQueue: shouldQueue,
      useCache: false,
    );
  }

  /// Retrieves the default options for Dio requests.
  ///
  /// This method returns an Options instance with followRedirects set to false
  /// and a custom validateStatus function that checks if the status code is less than 501.
  Options _getDioOptions() {
    return Options(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 501;
      },
    );
  }
}
