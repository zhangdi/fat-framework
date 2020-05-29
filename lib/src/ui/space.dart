part of fat_framework;

class FatSpace extends StatelessWidget {
  final double width;
  final double height;

  FatSpace({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
    );
  }
}
