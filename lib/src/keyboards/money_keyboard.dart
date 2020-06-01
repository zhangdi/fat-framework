part of fat_framework;

/// 金额键盘
class FatMoneyKeyboard extends StatefulWidget {
  final double height;
  final FatKeyboardController controller;
  final FatKeyboardManager keyboardManager;

  static FatTextInputType inputType = FatTextInputType(
    name: 'TextInput.money',
  );

  FatMoneyKeyboard({
    Key key,
    @required this.height,
    @required this.controller,
    @required this.keyboardManager,
  })  : assert(height != null && height > 0),
        assert(controller != null),
        assert(keyboardManager != null),
        super(key: key);

  @override
  _FatMoneyKeyboardState createState() => _FatMoneyKeyboardState();
}

class _FatMoneyKeyboardState extends State<FatMoneyKeyboard> {
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    Size size = mediaQueryData.size;

    double borderHeight = 1 / mediaQueryData.devicePixelRatio;

    double cellWidth = size.width / 4;
    double cellHeight = (widget.height - borderHeight) / 4;

    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.height,
        maxWidth: size.width,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border(
          top: BorderSide(color: Colors.grey, width: borderHeight),
        ),
      ),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('1'),
                    onPressed: () {
                      widget.controller.handleInput('1');
                    },
                  ),
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('2'),
                    onPressed: () {
                      widget.controller.handleInput('2');
                    },
                  ),
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('3'),
                    onPressed: () {
                      widget.controller.handleInput('3');
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('4'),
                    onPressed: () {
                      widget.controller.handleInput('4');
                    },
                  ),
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('5'),
                    onPressed: () {
                      widget.controller.handleInput('5');
                    },
                  ),
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('6'),
                    onPressed: () {
                      widget.controller.handleInput('6');
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('7'),
                    onPressed: () {
                      widget.controller.handleInput('7');
                    },
                  ),
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('8'),
                    onPressed: () {
                      widget.controller.handleInput('8');
                    },
                  ),
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('9'),
                    onPressed: () {
                      widget.controller.handleInput('9');
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('0'),
                    onPressed: () {
                      widget.controller.handleInput('0');
                    },
                  ),
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    color: Colors.grey[200],
                    child: _buildNumber('.'),
                    onPressed: () {
                      widget.controller.handleInput('.');
                    },
                  ),
                  _buildCell(
                    width: cellWidth,
                    height: cellHeight,
                    child: _buildNumber('00'),
                    onPressed: () {
                      widget.controller.handleInput('00');
                    },
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              _buildHideKeyboard(
                width: cellWidth,
                height: cellHeight,
              ),
              _buildDelete(
                width: cellWidth,
                height: cellHeight,
              ),
              _buildDone(
                width: cellWidth,
                height: cellHeight * 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDone({
    double width,
    double height,
  }) {
    String label = '完成';
    if (widget.controller.client.configuration.inputAction == TextInputAction.next) {
      label = '下一个';
    }
    return _buildCell(
      width: width,
      height: height,
      color: Colors.blueAccent,
      child: Text(
        label,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      onPressed: () {
        if (widget.controller.client.configuration.inputAction == TextInputAction.done) {
          widget.controller.actionDone();
        } else if (widget.controller.client.configuration.inputAction == TextInputAction.next) {
          widget.controller.actionNext();
        }
      },
    );
  }

  Widget _buildHideKeyboard({
    double width,
    double height,
  }) {
    return _buildCell(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        Icons.keyboard_arrow_down,
        size: 32,
      ),
      onPressed: () {
        widget.keyboardManager.hideKeyboard();
      },
    );
  }

  Widget _buildNumber(String value) {
    return Text(
      value,
      style: TextStyle(fontSize: 24, color: Colors.black),
    );
  }

  Widget _buildDelete({
    double width,
    double height,
  }) {
    return _buildCell(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Text(
        '删除',
        style: TextStyle(color: Colors.red, fontSize: 18),
      ),
      onPressed: widget.controller.handleDelete,
      onLongPressed: () async {
        widget.controller.clear();
      },
    );
  }

  Widget _buildCell({
    double width,
    double height,
    Widget child,
    VoidCallback onPressed,
    VoidCallback onLongPressed,
    Color color = Colors.white,
  }) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(6),
      child: Container(
        width: width - 12,
        height: height - 12,
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: onPressed,
            onLongPress: onLongPressed,
            borderRadius: BorderRadius.circular(4),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
