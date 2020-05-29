part of fat_framework;

class FatGridIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final Widget label;

  FatGridIconButton({@required this.icon, this.onPressed, @required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            icon,
            SizedBox(
              height: 4,
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              child: label,
            ),
          ],
        ),
      ),
    );
  }
}
