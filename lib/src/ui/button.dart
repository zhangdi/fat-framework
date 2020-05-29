part of fat_framework;

/// 按钮类型
enum FatButtonType {
  light,
  dark,
  primary,
  success,
  warning,
  danger,
}

// 按钮形状
enum FatButtonShape {
  // 圆角矩形
  round,
  // 圆形按钮
  circle,
}

/// 按钮尺寸
enum FatButtonSize {
  normal,
  large,
  small,
  mini,
}

final Map<FatButtonType, Color> kFatButtonColors = {
  FatButtonType.light: Colors.grey[300],
  FatButtonType.dark: Colors.grey[800],
  FatButtonType.primary: Colors.blue,
  FatButtonType.success: Colors.green,
  FatButtonType.warning: Colors.orange,
  FatButtonType.danger: Colors.red,
};

final Map<FatButtonType, Color> kFatButtonTextColors = {
  FatButtonType.light: Colors.black,
  FatButtonType.dark: Colors.black,
  FatButtonType.primary: Colors.white,
  FatButtonType.success: Colors.white,
  FatButtonType.warning: Colors.white,
  FatButtonType.danger: Colors.white,
};

final Map<FatButtonType, Color> kFatOutlineButtonTextColors = {
  FatButtonType.light: Colors.black,
  FatButtonType.dark: Colors.black,
  FatButtonType.primary: Colors.blue[700],
  FatButtonType.success: Colors.green[700],
  FatButtonType.warning: Colors.orange[700],
  FatButtonType.danger: Colors.red[700],
};

final Map<FatButtonSize, double> kFatButtonSizes = {
  FatButtonSize.normal: 14,
  FatButtonSize.large: 18,
  FatButtonSize.small: 12,
  FatButtonSize.mini: 10,
};

final Map<FatButtonSize, EdgeInsets> kFatButtonPaddings = {
  FatButtonSize.normal: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  FatButtonSize.large: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  FatButtonSize.small: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  FatButtonSize.mini: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
};

final Map<FatButtonSize, BorderRadius> kFatButtonRoundBorderRadius = {
  FatButtonSize.normal: BorderRadius.circular(4),
  FatButtonSize.large: BorderRadius.circular(8),
  FatButtonSize.small: BorderRadius.circular(2),
  FatButtonSize.mini: BorderRadius.circular(1),
};

final Map<FatButtonSize, BorderRadius> kFatButtonCircleBorderRadius = {
  FatButtonSize.normal: BorderRadius.circular(100),
  FatButtonSize.large: BorderRadius.circular(100),
  FatButtonSize.small: BorderRadius.circular(100),
  FatButtonSize.mini: BorderRadius.circular(100),
};

class FatButton extends StatefulWidget {
  final FatButtonType type;
  final FatButtonShape shape;
  final FatButtonSize size;
  final bool outline;
  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  final bool loading;
  final bool enabled;

  FatButton({
    Key key,
    @required this.child,
    this.type = FatButtonType.primary,
    this.size = FatButtonSize.normal,
    this.outline = false,
    this.shape = FatButtonShape.round,
    this.onPressed,
    this.onLongPressed,
    this.loading = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  FatButtonState createState() => FatButtonState();
}

class FatButtonState extends State<FatButton> {
  bool _loading = false;

  /// 设置 loading 状态
  void setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  @override
  void initState() {
    super.initState();
    _loading = widget.loading;
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = kFatButtonColors[widget.type];
    Color textColor = kFatButtonTextColors[widget.type];
    double textSize = kFatButtonSizes[widget.size];
    BorderRadius borderRadius;
    Border border;
    EdgeInsets padding = kFatButtonPaddings[widget.size];

    if (widget.shape == FatButtonShape.round) {
      borderRadius = kFatButtonRoundBorderRadius[widget.size];
    } else if (widget.shape == FatButtonShape.circle) {
      borderRadius = kFatButtonCircleBorderRadius[widget.size];
    }

    if (widget.outline) {
      backgroundColor = backgroundColor.withOpacity(0.2);
      textColor = kFatOutlineButtonTextColors[widget.type];
      border = Border.all(color: kFatButtonColors[widget.type], width: 0.6);
    }

    Widget content = widget.child;

    if (_loading) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(textColor),
            ),
            width: textSize * 1.2,
            height: textSize * 1.2,
          ),
          SizedBox(
            width: textSize,
          ),
          widget.child,
        ],
      );
    }

    return FatRawButton(
      child: content,
      backgroundColor: _loading || !widget.enabled ? backgroundColor.withOpacity(0.75) : backgroundColor,
      textColor: textColor,
      textSize: textSize,
      borderRadius: borderRadius,
      border: border,
      padding: padding,
      onPressed: _loading || !widget.enabled ? null : widget.onPressed,
      onLongPressed: _loading || !widget.enabled ? null : widget.onLongPressed,
    );
  }
}

class FatRawButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color textColor;
  final double textSize;
  final BorderRadius borderRadius;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  final Border border;
  final EdgeInsets padding;

  FatRawButton({
    Key key,
    this.child,
    this.backgroundColor,
    this.textColor,
    this.textSize,
    this.borderRadius,
    this.onPressed,
    this.onLongPressed,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onPressed,
        onLongPress: onLongPressed,
        borderRadius: borderRadius,
        highlightColor: Colors.white.withOpacity(0.1),
        child: Container(
          child: DefaultTextStyle(
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
            ),
            child: IconTheme(
              data: IconThemeData(color: textColor),
              child: child,
            ),
          ),
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: border,
          ),
        ),
      ),
    );
  }
}
