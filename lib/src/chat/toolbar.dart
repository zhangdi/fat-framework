part of fat_framework;

class FatChatToolbar extends StatefulWidget {
  final SendTextCallback onSendText;
  final List<Widget> extraToolbarChildren;
  final bool showExtraToolbar;
  final ExtraToolbarVisibleChanged onExtraToolbarVisibleChanged;

  FatChatToolbar({
    Key key,
    this.onSendText,
    this.extraToolbarChildren = const [],
    this.showExtraToolbar = false,
    this.onExtraToolbarVisibleChanged,
  }) : super(key: key);

  @override
  FatChatToolbarState createState() => FatChatToolbarState();
}

class FatChatToolbarState extends State<FatChatToolbar> {
  FocusNode _textFocusNode = FocusNode();
  TextEditingController _textController = TextEditingController();

  // 是否显示发送按钮
  bool _showSendButton = false;

  // 是否显示扩展按钮
  bool _showExtraButton = true;

  // 是否显示扩展工具栏
  bool _showExtraToolbar = false;

  ThemeData mTheme;

  @override
  void initState() {
    super.initState();
    _showExtraToolbar = widget.showExtraToolbar;

    _textFocusNode.addListener(() {
      if (_textFocusNode.hasFocus) {
        setShowExtraToolbar(false);
      }
    });

    _textController.addListener(() {
      if (_textController.text != null && _textController.text.length > 0) {
        setState(() {
          _showSendButton = true;
          _showExtraButton = false;
        });
      } else {
        setState(() {
          _showSendButton = false;
          _showExtraButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  void setShowExtraToolbar(bool visible) {
    setState(() {
      _showExtraToolbar = visible;
    });

    if (visible) {
      FocusScope.of(context).requestFocus(FocusNode());
    }

    if (widget.onExtraToolbarVisibleChanged != null) {
      widget.onExtraToolbarVisibleChanged(visible);
    }
  }

  @override
  Widget build(BuildContext context) {
    mTheme = Theme.of(context);

    List<Widget> children = [];

    children.add(Expanded(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          focusNode: _textFocusNode,
          controller: _textController,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
          ),
        ),
      ),
    ));

    // 显示扩展按钮
    if (_showExtraButton) {
      children.add(SizedBox(width: 12));

      children.add(FatCircleIconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          setShowExtraToolbar(!_showExtraToolbar);
        },
      ));
    }

    // 显示发送按钮
    if (_showSendButton) {
      children.add(SizedBox(
        width: 12,
      ));

      children.add(FatButton(
        child: Text('发送'),
        onPressed: _onSendText,
      ));
    }

    List<Widget> columns = [
      Container(
        height: kToolbarHeight,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(top: 8, right: 16, bottom: 12, left: 16),
        decoration: BoxDecoration(
          color: mTheme.scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: mTheme.dividerColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      )
    ];

    if (_showExtraToolbar) {
      columns.add(FatChatExtraToolbar(
        items: widget.extraToolbarChildren,
      ));
    }

    return Container(
      height: height,
      width: double.infinity,
      child: Column(
        children: columns,
      ),
    );
  }

  double get height => kFatChatToolbarHeight + (_showExtraToolbar ? kFatChatExtraToolbarHeight : 0);

  _onSendText() {
    if (_textController.text != null && _textController.text.length > 0) {
      if (widget.onSendText != null) {
        widget.onSendText(_textController.text);

        _textController.clear();
      }
    }
  }
}
