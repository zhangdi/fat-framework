part of fat_framework;

/// WebSocket 消息
class FatWebSocketMessage {
  // 动作
  String action;

  // 参数
  Map<String, dynamic> params;

  // 数据
  Map<String, dynamic> data;

  /// 创建 WebSocket 消息
  FatWebSocketMessage.create({
    @required this.action,
    this.params,
    this.data,
  }) {
    assert(action != null);
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'params': params,
      'data': data,
    };
  }

  FatWebSocketMessage.fromMap(Map<String, dynamic> map) {
    action = map['action'];
    params = map['params'];
    data = map['data'];
  }

  @override
  String toString() {
    return json.encode(toMap());
  }
}

/// WebSocket 动作处理程序
typedef FatWebSocketActionHandler = Function(FatWebSocketMessage message);
