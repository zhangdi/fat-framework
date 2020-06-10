part of fat_framework;

class FatOverlayOptions {
  // 悬浮窗是否最小化
  bool minimize = false;
  Function(bool minimize) onMinimize;

  /// 最小化尺寸
  Size miniSize;

  /// 悬浮窗是否可拖动
  bool draggable = false;
}

/// 悬浮窗管理
class FatOverlayManager extends FatService {
  static const OVERLAY_NAME = 'default';

  Map<String, OverlayEntry> _overlays = Map();
  Map<String, FatOverlayOptions> _overlayOptions = Map<String, FatOverlayOptions>();
  Map<String, GlobalKey<_FatOverlayWrapperState>> _overlayKeys = Map<String, GlobalKey<_FatOverlayWrapperState>>();

  /// 显示
  void show(
    BuildContext context,
    Widget child, {
    String name = OVERLAY_NAME,
    FatOverlayOptions options,
  }) {
    /// 如果有悬浮窗，则先移除
    remove(name: name);

    GlobalKey<_FatOverlayWrapperState> _key = GlobalKey<_FatOverlayWrapperState>();

    OverlayEntry entry = OverlayEntry(
      builder: (context) {
        return _FatOverlayWrapper(
          name: name,
          manager: this,
          key: _key,
          child: child,
          options: options,
        );
        return child;
      },
    );

    _overlays[name] = entry;
    _overlayOptions[name] = options;
    _overlayKeys[name] = _key;

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
      _overlayOptions.removeWhere((key, value) => key == name);
      _overlayKeys.removeWhere((key, value) => key == name);
    }
  }

  /// 获取指定悬浮窗选项
  FatOverlayOptions getOptions(String name) {
    return _overlayOptions[name];
  }

  /// 设置指定悬浮窗的选项
  void setOptions(String name, FatOverlayOptions options) {
    _overlayOptions[name] = options;
    _overlayKeys[name].currentState?.setOptions(options);
  }
}

class _FatOverlayWrapper extends StatefulWidget {
  final String name;
  final Widget child;
  final FatOverlayOptions options;
  final FatOverlayManager manager;

  _FatOverlayWrapper({
    Key key,
    @required this.name,
    @required this.child,
    @required this.options,
    @required this.manager,
  })  : assert(name != null),
        assert(child != null),
        assert(options != null),
        assert(manager != null),
        super(key: key);

  @override
  _FatOverlayWrapperState createState() => _FatOverlayWrapperState();
}

class _FatOverlayWrapperState extends State<_FatOverlayWrapper> {
  FatOverlayOptions _options;

  double _offsetTop;
  double _offsetLeft;

  @override
  void initState() {
    super.initState();

    _options = widget.options;
  }

  Offset _dragStartOffset;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryData.fromWindow(window);
    if (_options.minimize) {
      double minTop = mediaQuery.padding.top;
      double maxTop = mediaQuery.size.height - (_options.miniSize.height + 16);
      double minLeft = 16;
      double maxLeft = mediaQuery.size.width - (_options.miniSize.width + 16);

      // 初始化位置
      if (_offsetTop == null) {
        _offsetTop = minTop;
      }
      if (_offsetLeft == null) {
        _offsetLeft = maxLeft;
      }
      Widget _child;
      if (_options.draggable) {
        _child = GestureDetector(
          onTap: () {
            final opt = widget.manager.getOptions(widget.name);
            opt.minimize = !opt.minimize;
            widget.manager.setOptions(widget.name, opt);
            if (opt.onMinimize != null) {
              opt.onMinimize(opt.minimize);
            }
          },
          onPanStart: (DragStartDetails details) {
            setState(() {
              _dragStartOffset = details.globalPosition;
            });
          },
          onPanUpdate: (DragUpdateDetails details) {
            double y = _offsetTop - (details.globalPosition.dy - _dragStartOffset.dy);
            double x = _offsetLeft - (details.globalPosition.dx - _dragStartOffset.dx);

            setState(() {
              _offsetLeft = x < minLeft ? minLeft : x > maxLeft ? maxLeft : x;
              _offsetTop = y < minTop ? minTop : y > maxTop ? maxTop : y;

              _dragStartOffset = details.globalPosition;
            });
          },
          onPanEnd: (DragEndDetails details) {
            setState(() {
              _dragStartOffset = null;
            });
          },
        );
      } else {
        _child = widget.child;
      }

      return Positioned(
        left: _offsetLeft,
        top: _offsetTop,
        width: _options.miniSize.width,
        height: _options.miniSize.height,
        child: _child,
      );
    } else {
      return Positioned(
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
        child: widget.child,
      );
    }
  }

  setOptions(FatOverlayOptions options) {
    setState(() {
      _options = options;
    });
  }
}
