part of fat_framework;

/// 自定义键盘容器
class FatKeyboardContainer extends StatefulWidget {
  final Widget child;

  FatKeyboardContainer({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  FatKeyboardContainerState createState() => FatKeyboardContainerState();
}

class FatKeyboardContainerState extends State<FatKeyboardContainer> {
  bool _visible = false;

  bool get visible => _visible;
  FatKeyboard _keyboard;
  FatKeyboardController _controller;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (_visible) {
      double height = _keyboard.heightGetter(
        context,
      );
      children.add(Positioned(
        top: 0,
        right: 0,
        bottom: height,
        left: 0,
        child: widget.child,
      ));
      children.add(Positioned(
        right: 0,
        height: height,
        bottom: 0,
        left: 0,
        child: _keyboard.builder(
          context,
          _controller,
        ),
      ));
    } else {
      children.add(Positioned(
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
        child: widget.child,
      ));
    }

    return MediaQuery(
      data: MediaQueryData.fromWindow(window),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: children,
        ),
      ),
    );
  }

  /// 显示键盘
  void show({
    FatKeyboard keyboard,
    FatKeyboardController controller,
  }) {
    setState(() {
      _visible = true;
      _keyboard = keyboard;
      _controller = controller;
    });
  }

  void hide() {
    setState(() {
      _visible = false;
      _keyboard = null;
    });
  }
}
