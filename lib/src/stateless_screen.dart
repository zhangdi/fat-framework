part of fat_framework;

abstract class FatStatelessScreen extends StatelessWidget implements FatScreen {
  @override
  Widget build(BuildContext context) {
    FatApplication.instance?.currentContext = context;

    return buildScreen(context);
  }
}
