part of fat_framework;

class FatBadge extends StatefulWidget {
  final Color color;
  final Widget child;
  final bool visible;

  FatBadge({
    this.color = Colors.red,
    this.child,
    this.visible = true,
  });

  @override
  _FatBadgeState createState() => _FatBadgeState();
}

class _FatBadgeState extends State<FatBadge> with TickerProviderStateMixin {
  AnimationController _animationController;
  Tween<Offset> _positionTween = Tween(
    begin: const Offset(-0.5, 0.9),
    end: const Offset(0.0, 0.0),
  );

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) {
      return Container(
        width: 0,
        height: 0,
      );
    }

    EdgeInsets padding;

    if (widget.child != null) {
      padding = EdgeInsets.symmetric(horizontal: 6, vertical: 3);
    }

    return SlideTransition(
      position: _positionTween.animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut)),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: padding,
          constraints: BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white, fontSize: 11),
            child: widget.child ??
                SizedBox(
                  width: 6,
                  height: 6,
                ),
          ),
        ),
      ),
    );
  }
}
