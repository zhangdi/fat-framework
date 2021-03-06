part of fat_framework;

abstract class FatProviderScreen<T extends FatProvider> extends FatStatelessScreen {
  final T mProvider;

  FatApplication application = FatApplication.instance;

  /// 构造函数
  ///
  FatProviderScreen(T provider) : mProvider = provider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: mProvider)],
      child: buildScreen(context),
    );
  }
}
