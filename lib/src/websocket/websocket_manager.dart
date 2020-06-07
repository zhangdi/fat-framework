part of fat_framework;

class FatWebSocket extends FatService {
  /// WebSocket 地址
  String url;

  /// WebSocket 参数
  Map<String, String> params;

  /// 重连时限
  Duration reconnectDuration;

  /// 是否开启重连
  bool enableReconnect;

  FatWebSocket(
    this.url, {
    this.params,
    this.enableReconnect = false,
    this.reconnectDuration = const Duration(seconds: 3),
  });

  WebSocket _webSocket;

  WebSocket get webSocket => _webSocket;

  Map<String, List<FatWebSocketActionHandler>> _actionHandlers = Map();

  Map<String, List<FatWebSocketActionHandler>> get actionHandlers => _actionHandlers;

  /// 连接 WebSocket 服务器
  connect() {
    var lastUrl = url;
    if (params != null && params.length > 0) {
      lastUrl += '?' + FatUrlUtil.buildUrlParams(params);
    }

    WebSocket.connect(lastUrl).then((value) {
      _webSocket = value;

      _webSocket.listen(
        _onReceiveMessage,
        onDone: _onDone,
        onError: _onError,
        cancelOnError: true,
      );
    }).catchError(_onConnectError);
  }

  _onConnectError(e) {
    _checkConnection();
  }

  void _onError(error, StackTrace stackTrace) {
    _checkConnection();
  }

  void _onDone() {
    _checkConnection();
  }

  void _onReceiveMessage(event) {
    try {
      FatWebSocketMessage message = FatWebSocketMessage.fromMap(json.decode(event));

      // 消息分发
      _handleAction(message.action, message);
    } catch (e) {
      print(e);
    }
  }

  void _checkConnection() {
    if (enableReconnect) {
      if (_needReconnect()) {
        // 需要重连
        Future.delayed(reconnectDuration, () {
          connect();
        });
      }
    }
  }

  /// 是否需要重新连接
  bool _needReconnect() {
    return _webSocket == null || _webSocket.readyState == WebSocket.closed;
  }

  /// 添加动作处理程序
  addActionHandler(String action, FatWebSocketActionHandler handler) {
    List<FatWebSocketActionHandler> handlers = _actionHandlers[action];
    if (handlers == null) {
      handlers = List<FatWebSocketActionHandler>();
    }

    handlers.add(handler);

    _actionHandlers[action] = handlers;
  }

  /// 处理动作
  _handleAction(String action, FatWebSocketMessage message) {
    List<FatWebSocketActionHandler> handlers = _actionHandlers[action];
    if (handlers == null) {
      print('AppWebSocket does not have any handlers for action "${action}".');
    } else {
      handlers.forEach((handler) {
        handler(message);
      });
    }
  }

  /// 发送消息
  send(FatWebSocketMessage message) {
    _webSocket.add(message.toString());
  }
}
