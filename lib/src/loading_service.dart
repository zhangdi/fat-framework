part of fat_framework;

/// 取消回调，正确回调请返回 true
typedef CancelCallback = Future<bool> Function();

class FatLoadingService extends FatService {
  bool _visible = false;
  GlobalKey<_FatLoadingDialogState> _loadingDialogKey = GlobalKey();

  void show({
    @required BuildContext context,
    String text,
    CancelCallback onCancel,
  }) {
    if (!_visible) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            child: FatLoadingDialog(
              key: _loadingDialogKey,
              text: text,
            ),
            onWillPop: () async {
              if (onCancel == null) {
                return true;
              } else {
                return await onCancel();
              }
            },
          );
        },
      );
    } else {
      _loadingDialogKey.currentState?.text = text;
    }

    _visible = true;
  }

  void hide({
    @required BuildContext context,
  }) {
    assert(context != null);

    if (_visible) {
      _visible = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class FatLoadingDialog extends StatefulWidget {
  final String text;

  FatLoadingDialog({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  _FatLoadingDialogState createState() => _FatLoadingDialogState();
}

class _FatLoadingDialogState extends State<FatLoadingDialog> {
  String _text;

  @override
  void initState() {
    super.initState();
    _text = widget.text;
  }

  @override
  void dispose() {
    super.dispose();
    _text = null;
  }

  set text(String text) {
    setState(() {
      _text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.1),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.6,
            maxHeight: screenSize.height * 0.6,
          ),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Color(0xFFFFFFFF)),
                ),
              ),
              FatSpace(
                height: 8,
                width: 0,
              ),
              Text(
                _text ?? '',
                style: TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
