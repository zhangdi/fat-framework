part of fat_framework;

/// 悬浮窗管理
class FatOverlayManager extends FatService {
  static const OVERLAY_NAME = 'default';

  Map<String, OverlayEntry> _overlays = Map();

  /// 显示
  void show(
    BuildContext context,
    Widget child, {
    String name = OVERLAY_NAME,
  }) {
    /// 如果有悬浮窗，则先移除
    remove(name: name);

    OverlayEntry entry = OverlayEntry(builder: (context) {
      return child;
    });

    _overlays[name] = entry;

    Overlay.of(context).insert(entry);
  }

  /// 判断 Overlay 是否存在
  bool isShown(String name) {
    return _overlays.containsKey(name);
  }

  /// 移除悬浮窗
  remove({
    String name = OVERLAY_NAME,
  }) {
    if (_overlays.containsKey(name)) {
      _overlays[name].remove();
      _overlays.removeWhere((key, value) => key == name);
    }
  }
}
