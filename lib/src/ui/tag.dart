part of fat_framework;

enum FatTagType {
  light,
  primary,
  success,
  warning,
  danger,
  info,
}

// 按钮形状
enum FatTagShape {
  none,
  // 圆角矩形
  round,
  // 圆形按钮
  circle,
}

final Map<FatTagType, Color> kFatTagBackgroundColors = {
  FatTagType.light: Colors.grey[600],
  FatTagType.primary: Colors.blueAccent[400],
  FatTagType.success: Colors.green[400],
  FatTagType.warning: Colors.deepOrange[400],
  FatTagType.danger: Colors.red[400],
  FatTagType.info: Colors.teal[400],
};

class FatTag extends StatelessWidget {
  final String text;
  final FatTagType type;
  final FatTagShape shape;

  FatTag({@required this.text, this.type = FatTagType.light, this.shape = FatTagShape.none}) : assert(text != null);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 4, vertical: 0);

    switch (shape) {
      case FatTagShape.none:
        break;
      case FatTagShape.round:
        borderRadius = BorderRadius.circular(4);
        break;
      case FatTagShape.circle:
        borderRadius = BorderRadius.circular(100);
        padding = EdgeInsets.symmetric(horizontal: 6, vertical: 0);
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: kFatTagBackgroundColors[type],
        borderRadius: borderRadius,
      ),
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 12, color: Colors.white),
        child: Text(text),
      ),
    );
  }
}
