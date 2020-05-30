part of fat_framework;

const SERVICE_ROUTER = 'fat.application.router';
const SERVICE_NAVIGATOR_KEY = 'fat.application.navigatorKey';
const SERVICE_PREFERENCES = 'fat.application.preferences';
const SERVICE_IDENTITY = 'fat.application.identity';
const SERVICE_TOAST = 'fat.application.toast';
const SERVICE_HTTP = 'fat.application.http';

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

  FatToastManager get toast => getService(SERVICE_TOAST);

  FatHttpService get http => getService(SERVICE_HTTP);

  bool get isProduct => bool.fromEnvironment("dart.vm.product");

  ThemeData theme;

  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

  InitializeCallback _initializeCallback;

  StateInitializeCallback _stateInitializeCallback;

  List<ChangeNotifierProvider> providers = [];

  /// 初始化
  initialize() async {
    _serviceLocator = FatServiceLocator();
    _eventBus = EventBus();
    _navigatorKey = GlobalKey();

    await _registerCoreServices();

    if (_initializeCallback != null) {
      await _initializeCallback(this);
    }
  }

  /// State 初始化
  initializeState(BuildContext context) async {
    _currentContext = context;

    if (_stateInitializeCallback != null) {
      await _stateInitializeCallback(this, context);
    }
  }

  /// 设置初始化回调
  /// 必须在 [initialize] 之前调用
  onInitialize(InitializeCallback callback) {
    _initializeCallback = callback;
  }

  /// 设置 State 初始化回调
  /// 必须在 [initialize] 之前调用
  onStateInitialize(StateInitializeCallback callback) {
    _stateInitializeCallback = callback;
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

    // Toast
    FatToastManager _toast = FatToastManager();
    await _toast.initialize();
    await registerService(SERVICE_TOAST, _toast);

    // HTTP
    FatHttpService _http = FatHttpService();
    await _http.initialize();
    await registerService(SERVICE_HTTP, _http);
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
    return MultiProvider(
      providers: providers,
      child: FatApplicationWrapper(application: this),
    );
  }
}

class FatApplicationWrapper extends StatefulWidget {
  FatApplication application;

  FatApplicationWrapper({
    @required this.application,
  }) : assert(application != null);

  @override
  _FatApplicationWrapperState createState() => _FatApplicationWrapperState();
}

class _FatApplicationWrapperState extends State<FatApplicationWrapper> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initialize();
    });
  }

  /// 初始化
  initialize() async {
    // 初始应用
    await widget.application.initializeState(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: widget.application.theme,
      onGenerateRoute: widget.application.router.onGenerateRoute,
      navigatorKey: widget.application.navigatorKey,
      navigatorObservers: widget.application.router.getNavigatorObservers(),
      localizationsDelegates: widget.application.localizationsDelegates,
    );
  }
}
