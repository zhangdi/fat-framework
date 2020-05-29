part of fat_framework;

abstract class FatService {
  bool _initialized = false;

  bool get initialized => _initialized;

  /// 初始化服务
  initialize() {
    _initialized = true;
  }
}
