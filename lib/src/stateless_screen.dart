part of fat_framework;

abstract class FatStatelessScreen extends StatelessWidget implements FatScreen {
  @override
  Widget build(BuildContext context) {
    return buildScreen(context);
  }
}
