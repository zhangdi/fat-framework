part of fat_framework;

abstract class FatStatefulScreen extends StatefulWidget {
  @override
  State createState() {
    return createScreenState();
  }

  ///
  FatScreenState createScreenState();
}

abstract class FatScreenState<T extends FatStatefulScreen> extends State<T> implements FatScreen {
  FatApplication application = FatApplication.instance;

  @override
  Widget build(BuildContext context) {
    return buildScreen(context);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      application.contextManager.push(context);

      onPostFirstFrameCallback(timeStamp);
    });
  }

  @override
  void dispose() {
    application.contextManager.pop(context);

    super.dispose();
  }

  ///
  void onPostFirstFrameCallback(Duration timeStamp) {}
}
