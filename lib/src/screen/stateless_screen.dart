part of fat_framework;

abstract class FatStatelessScreen extends StatelessWidget implements FatScreen {
  FatApplication application = FatApplication.instance;

  @override
  Widget build(BuildContext context) {
    return buildScreen(context);
  }
}
