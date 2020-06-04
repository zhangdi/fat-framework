part of fat_framework;

typedef InitializeCallback = Function(FatApplication application);

typedef StateInitializeCallback = Function(FatApplication application, BuildContext context);

typedef HttpResponseHandler = dynamic Function(Response response);

/// 升级检查器
typedef UpgradeCheckHandler = Future<FatAppVersion> Function();

/// 升级处理程序
typedef UpgradeHandler = Future<bool> Function(FatAppVersion version);

/// 发送文本回调
typedef SendTextCallback = Function(String text);

/// 发送图片回调
typedef SendPicCallback = FatChatMessage Function(File pic);

/// 扩展工具栏显示回调
typedef ExtraToolbarVisibleChanged = Function(bool visible);

/// 会话初始化回调
typedef ChatInitialCallback = Future Function();
