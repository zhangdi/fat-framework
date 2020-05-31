part of fat_framework;

typedef InitializeCallback = Function(FatApplication application);

typedef StateInitializeCallback = Function(FatApplication application, BuildContext context);

typedef HttpResponseHandler = dynamic Function(Response response);

/// 升级检查器
typedef UpgradeCheckHandler = Future<FatAppVersion> Function();

/// 升级处理程序
typedef UpgradeHandler = Future<bool> Function(FatAppVersion version);
