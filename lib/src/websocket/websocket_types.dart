part of fat_framework;

/// WebSocket 动作
class FatWebSocketAction {
  final String name;

  const FatWebSocketAction({
    @required this.name,
  }) : assert(name != null);
}

/// WebSocket 消息
class FatWebSocketMessage {
  // 动作
  FatWebSocketAction action;

  // 参数
  Map<String, dynamic> params;

  // 数据
  Map<String, dynamic> data;

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'params': params,
      'data': data,
    };
  }

  FatWebSocketMessage.fromMap(Map<String, dynamic> map) {
    action = map['action'] == null ? null : FatWebSocketAction(name: map['action']);
    params = map['params'];
    data = map['data'];
  }
}

/// WebSocket 动作处理程序
typedef FatWebSocketActionHandler = Function(FatWebSocketMessage message);
