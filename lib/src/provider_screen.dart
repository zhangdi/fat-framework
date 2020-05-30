part of fat_framework;

abstract class FatProviderScreen<T extends FatProvider> extends FatStatelessScreen {
  final T mProvider;

  /// 构造函数
  ///
  FatProviderScreen(T provider) : mProvider = provider;

  @override
  Widget build(BuildContext context) {
    FatApplication.instance?.currentContext = context;

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: mProvider)],
      child: buildScreen(context),
    );
  }
}
