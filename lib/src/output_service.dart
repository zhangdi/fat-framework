part of fat_framework;

class FatOutputService extends FatService {
  void _print(String message, {bool withTimestamp = true}) {
    List<String> lines = [];
    if (withTimestamp) {
      lines.add('[${timestamp()}]: ');
    }
    lines.add(message);

    debugPrint(lines.join());
  }

  /// 打印信息
  void print(String message, {bool withTimestamp = true}) {
    _print(message, withTimestamp: withTimestamp);
  }

  /// 获取时间戳
  String timestamp() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().substring(0, 2)}';
  }
}
