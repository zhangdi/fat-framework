part of fat_framework;

class FatFlatIcon extends StatelessWidget {
  final double size;
  final Widget child;
  final Color backgroundColor;
  final Color color;
  final BorderRadius borderRadius;

  FatFlatIcon(
    this.child, {
    this.size = 40,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.color = Colors.black,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: IconTheme(
        data: IconThemeData(color: color, size: this.size * 0.6),
        child: child,
      ),
    );
  }
}
