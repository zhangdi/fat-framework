part of fat_framework;

class FatIntStepper extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;
  final int step;
  final int min;
  final int max;

  FatIntStepper({
    Key key,
    this.initialValue,
    this.onChanged,
    @required this.step,
    this.min = null,
    this.max = null,
  })  : assert(step != null),
        super(key: key);

  @override
  FatIntStepperState createState() => FatIntStepperState();
}

class FatIntStepperState extends State<FatIntStepper> {
  int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? widget.min ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final mediaData = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300], width: 1 / mediaData.devicePixelRatio),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: _sub,
            child: Container(
              width: 28,
              height: 28,
              color: Colors.grey[300],
              child: Icon(
                Icons.remove,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Container(
            height: 28,
            constraints: BoxConstraints(
              minWidth: 28,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8),
            color: Colors.grey[100],
            child: Text(
              '${value ?? ''}',
              style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          InkWell(
            onTap: _add,
            child: Container(
              width: 28,
              height: 28,
              color: Colors.grey[300],
              child: Icon(
                Icons.add,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 加上
  _add() {
    final oldValue = value;
    final newValue = oldValue + widget.step;

    setState(() {
      if (widget.max != null && newValue > widget.max) {
        value = oldValue;
      } else {
        value = newValue;
      }
    });
  }

  /// 减去
  _sub() {
    final oldValue = value;
    final newValue = oldValue - widget.step;

    setState(() {
      if (widget.min != null && newValue < widget.min) {
        value = oldValue;
      } else {
        value = newValue;
      }
    });
  }

  int get value => _value;

  set value(int value) {
    setState(() {
      _value = value;
    });

    if (widget.onChanged != null) {
      widget.onChanged(_value);
    }
  }
}
