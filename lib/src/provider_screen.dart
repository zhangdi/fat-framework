part of fat_framework;

abstract class ProviderScreen<T extends FatProvider> extends FatStatelessScreen {
  final T mProvider;

  /// 构造函数
  ///
  ProviderScreen(T provider) : mProvider = provider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: mProvider)],
      child: buildScreen(context),
    );
  }
}
