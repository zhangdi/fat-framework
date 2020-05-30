part of fat_framework;

class FatHttpStatus {
  static const STATUS_OK = 200;
  static const STATUS_UNAUTHORIZED = 401;
}

class FatHttpService extends FatService {
  Dio _client;
  FatOutputService output;

  FatHttpService({
    @required this.output,
  }) : assert(output != null);

  @override
  initialize() {
    super.initialize();

    _client = Dio(BaseOptions(
      responseType: responseType,
      baseUrl: _baseUrl,
    ));

    _client.interceptors.add(debugInterceptor());
  }

  ResponseType _responseType = ResponseType.json;

  ResponseType get responseType => _responseType;

  set responseType(ResponseType value) {
    _responseType = value;

    _client.options.responseType = _responseType;
  }

  String _baseUrl;

  String get baseUrl => _baseUrl;

  set baseUrl(String value) {
    _baseUrl = value;

    _client.options.baseUrl = _baseUrl;
  }

  HttpResponseHandler _responseHandler;

  HttpResponseHandler get responseHandler => _responseHandler;

  set responseHandler(HttpResponseHandler value) {
    _responseHandler = value;
  }

  /// 添加拦截器
  void addInterceptor(Interceptor interceptor) {
    _client.interceptors.add(interceptor);
  }

  /// 设置头信息
  void setHeaders(Map<String, dynamic> headers) {
    _client.options.headers = headers;
  }

  /// 添加头信息
  void addHeader(String name, dynamic value) {
    _client.options.headers.addAll({name: value});
  }

  /// 添加头信息
  void addHeaders(Map<String, dynamic> headers) {
    _client.options.headers.addAll(headers);
  }

  /// 调试拦截器
  Interceptor debugInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options) {
        List<String> lines = [];

        lines.add('${options.method} ${options.path}');
        lines.add('Headers: ${options.headers}');
        lines.add('Query Parameters: ${options.queryParameters}');

        if (options.data != null) {
          lines.add('Data: ${options.data}');
        }

        output.print(lines.join('\n'), withTimestamp: false);

        return options;
      },
      onResponse: (response) {
        List<String> lines = [];

        lines.add('Response Status Code: ${response.statusCode}');
        lines.add('Response Status Message: ${response.statusMessage}');
        lines.add('Response Headers: ${response.headers}');
        lines.add('Response Data: ${response.data}');

        output.print(lines.join('\n'), withTimestamp: false);

        return response;
      },
      onError: (error) {
        output.print('Dio Error: ${error.toString()}', withTimestamp: false);

        return error;
      },
    );
  }

  /// GET 请求
  Future<T> get<T>(
    String path, {
    Map<String, dynamic> params,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    var resp = await _client.get(path, queryParameters: params, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress);

    return _handleResponse(resp);
  }

  /// POST 请求
  Future<T> post<T>(String path, {data, Map<String, dynamic> params, Options options, CancelToken cancelToken, ProgressCallback onSendProgress, ProgressCallback onReceiveProgress}) async {
    var resp = await _client.post(path, data: data, queryParameters: params, options: options, cancelToken: cancelToken, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress);

    return _handleResponse(resp);
  }

  /// DELETE 请求
  Future<T> delete<T>(
    String path, {
    data,
    Map<String, dynamic> params,
    Options options,
    CancelToken cancelToken,
  }) async {
    var resp = await _client.delete(path, data: data, queryParameters: params, options: options, cancelToken: cancelToken);

    return _handleResponse(resp);
  }

  dynamic _handleResponse(Response resp) {
    if (_responseHandler == null) {
      return resp;
    } else {
      return _responseHandler(resp);
    }
  }
}
