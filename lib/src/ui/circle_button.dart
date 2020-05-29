part of fat_framework;

class FatCircleIconButton extends StatefulWidget {
  final double size;
  final VoidCallback onPressed;
  final Widget icon;
  final Color color;

  FatCircleIconButton({
    @required this.icon,
    this.onPressed,
    this.size = 32,
    this.color = Colors.black,
  });

  @override
  _FatCircleIconButtonState createState() => _FatCircleIconButtonState();
}

class _FatCircleIconButtonState extends State<FatCircleIconButton> {
  Color _color;

  @override
  void initState() {
    super.initState();

    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: widget.onPressed,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          border: Border.all(color: _color, width: 1.5),
          borderRadius: BorderRadius.circular(widget.size),
        ),
        child: IconTheme(
          data: IconThemeData(
            color: _color,
          ),
          child: widget.icon,
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    setState(() {
      _color = widget.color.withOpacity(0.5);
    });
  }

  _onTapUp(TapUpDetails details) {
    setState(() {
      _color = widget.color;
    });
  }
}
