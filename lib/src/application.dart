part of fat_framework;

const SERVICE_ROUTER = 'fat.application.router';
const SERVICE_NAVIGATOR_KEY = 'fat.application.navigatorKey';
const SERVICE_PREFERENCES = 'fat.application.preferences';
const SERVICE_IDENTITY = 'fat.application.identity';

class FatApplication {
  FatServiceLocator _serviceLocator;
  EventBus _eventBus;
  GlobalKey<NavigatorState> _navigatorKey;

  BuildContext _currentContext;

  FatApplication._();

  static FatApplication _instance;

  factory FatApplication() {
    if (_instance == null) {
      _instance = FatApplication._();
    }
    return _instance;
  }

  BuildContext get currentContext => _currentContext;

  set currentContext(BuildContext value) {
    _currentContext = value;
  }

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  FatRouter get router => getService(SERVICE_ROUTER);

  FatPreferenceManager get preferences => getService(SERVICE_PREFERENCES);

  bool get isProduct => bool.fromEnvironment("dart.vm.product");

  /// 初始化
  initialize() async {
    _serviceLocator = FatServiceLocator();
    _eventBus = EventBus();
    _navigatorKey = GlobalKey();

    await _registerCoreServices();
  }

  /// 核心服务
  _registerCoreServices() async {
    // 路由服务
    FatRouter _router = FatRouter(navigatorKey: _navigatorKey);
    await _router.initialize();
    await registerService(SERVICE_ROUTER, _router);

    // PreferenceManager
    FatPreferenceManager _prefs = FatPreferenceManager();
    await _prefs.initialize();
    await registerService(SERVICE_PREFERENCES, _prefs);
  }

  /// 注册服务
  registerService<T extends FatService>(String name, T service) {
    _serviceLocator.registerSingleton(name, service);
  }

  /// 获取服务
  getService<T extends FatService>(String name) {
    return _serviceLocator.getSingleton(name);
  }

  /// 事件监听
  Stream<T> on<T>() {
    return _eventBus.on<T>();
  }

  Widget run() {
    return MaterialApp();
  }
}
