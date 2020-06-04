part of fat_framework;

enum FatChatMessageAlign {
  leftToRight,
  rightToLeft,
}

const Map<FatChatMessageAlign, Color> kFatChatMessageBackgroundColors = {
  FatChatMessageAlign.leftToRight: Colors.white,
  FatChatMessageAlign.rightToLeft: Colors.blueAccent,
};

const Map<FatChatMessageAlign, Alignment> kFatChatMessageAlignments = {
  FatChatMessageAlign.leftToRight: Alignment.centerLeft,
  FatChatMessageAlign.rightToLeft: Alignment.centerRight,
};

typedef FatChatMessageContentBuilder = Widget Function(BuildContext context, double maxWidth);

class FatChatMessage extends StatefulWidget {
  final FatChatMessageAlign align;
  final Widget avatar;
  final Widget user;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  final FatChatMessageContentBuilder builder;
  final debug = false;

  FatChatMessage({
    @required this.builder,
    this.user,
    this.align = FatChatMessageAlign.leftToRight,
    this.avatar,
    this.onPressed,
    this.onLongPressed,
  });

  @override
  FatChatMessageState createState() => FatChatMessageState();
}

class FatChatMessageState extends State<FatChatMessage> {
  double _avatarWidth = 40;
  double _placeholderWidth = 96;
  double _gutterWidth = 16;

  Widget get gutter => Container(
        width: _gutterWidth,
        height: _gutterWidth,
        color: widget.debug ? Colors.amber : Colors.transparent,
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    Widget placeholder = Expanded(
      child: Container(
        color: widget.debug ? Colors.red[300] : Colors.transparent,
        height: 20,
      ),
    );

    switch (widget.align) {
      case FatChatMessageAlign.leftToRight:
        if (widget.avatar != null) {
          children.add(_buildAvatar());
          children.add(gutter);
        }
        children.add(_buildContent());
        children.add(placeholder);

        break;
      case FatChatMessageAlign.rightToLeft:
        children.add(placeholder);

        children.add(_buildContent());

        if (widget.avatar != null) {
          children.add(gutter);
          children.add(_buildAvatar());
        }
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: _gutterWidth),
      margin: EdgeInsets.symmetric(vertical: _gutterWidth / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        child: widget.avatar,
      ),
    );
  }

  Widget _buildContent() {
    Color backgroundColor = kFatChatMessageBackgroundColors[widget.align];
    double contentWidth = MediaQuery.of(context).size.width;
    CrossAxisAlignment crossAxisAlignment;
    if (widget.align == FatChatMessageAlign.leftToRight) {
      crossAxisAlignment = CrossAxisAlignment.start;
    }

    if (widget.align == FatChatMessageAlign.rightToLeft) {
      crossAxisAlignment = CrossAxisAlignment.end;
    }

    // 去掉两边
    contentWidth = contentWidth - _gutterWidth * 2;
    // 去掉placeholder
    contentWidth = contentWidth - _placeholderWidth;
    // 去掉 progress
    contentWidth = contentWidth - _gutterWidth;

    if (widget.avatar != null) {
      contentWidth = contentWidth - _avatarWidth;
    }

    List<Widget> children = [];

    if (widget.user != null) {
      children.add(DefaultTextStyle(
        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        child: widget.user,
      ));
      children.add(Container(
        height: 4,
      ));
    }

    children.add(ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: widget.onPressed,
          onLongPress: widget.onLongPressed,
          child: Container(
            alignment: kFatChatMessageAlignments[widget.align],
            decoration: BoxDecoration(),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              child: widget.builder(context, contentWidth),
            ),
          ),
        ),
      ),
    ));

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}

typedef IndexedOnPressed = Function(int index);

class FatChatMessagePicContent extends StatelessWidget {
  final ImageProvider imageProvider;
  final IndexedOnPressed onPressed;
  final double maxWidth;
  final int index;

  FatChatMessagePicContent({
    @required this.index,
    @required this.imageProvider,
    @required this.maxWidth,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red,
      child: InkWell(
        child: Image(
          image: imageProvider,
          width: maxWidth,
          fit: BoxFit.fitWidth,
        ),
        onTap: () {
          if (onPressed != null) {
            onPressed(index);
          }
        },
      ),
    );
  }
}
