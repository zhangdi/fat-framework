part of fat_framework;

const SERVICE_ROUTER = 'fat.application.router';
const SERVICE_NAVIGATOR_KEY = 'fat.application.navigatorKey';
const SERVICE_PREFERENCES = 'fat.application.preferences';
const SERVICE_IDENTITY = 'fat.application.identity';
const SERVICE_TOAST = 'fat.application.toast';
const SERVICE_HTTP = 'fat.application.http';
const SERVICE_OUTPUT = 'fat.application.output';
const SERVICE_LOADING = 'fat.application.loading';
const SERVICE_UPGRADER = 'fat.application.upgrader';
const SERVICE_KEYBOARD = 'fat.application.keyboard';
const SERVICE_DEVICE = 'fat.application.device';
const SERVICE_VIBRATION = 'fat.application.vibration';
const SERVICE_OVERLAY = 'fat.application.overlay';
const SERVICE_NOTIFICATION = 'fat.application.notification';

class FatApplication {
  FatServiceLocator _serviceLocator;
  EventBus _eventBus;
  GlobalKey<NavigatorState> _navigatorKey;
  GlobalKey<FatKeyboardContainerState> _keyboardContainerKey = GlobalKey();

  BuildContext _currentContext;

  FatApplication._();

  static FatApplication _instance;

  static FatApplication get instance => _instance;

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

  PackageInfo _packageInfo;

  PackageInfo get packageInfo => _packageInfo;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  FatRouter get router => getService<FatRouter>(SERVICE_ROUTER);

  FatPreferenceManager get preferences => getService<FatPreferenceManager>(SERVICE_PREFERENCES);

  FatToastManager get toast => getService<FatToastManager>(SERVICE_TOAST);

  FatHttpService get http => getService<FatHttpService>(SERVICE_HTTP);

  FatOutputService get output => getService<FatOutputService>(SERVICE_OUTPUT);

  /// Loading
  FatLoadingService get loading => getService<FatLoadingService>(SERVICE_LOADING);

  /// 升级管理
  FatUpgradeService get upgrader => getService<FatUpgradeService>(SERVICE_UPGRADER);

  /// 键盘管理
  FatKeyboardManager get keyboard => getService<FatKeyboardManager>(SERVICE_KEYBOARD);

  /// 设备管理
  FatDeviceManager get device => getService<FatDeviceManager>(SERVICE_DEVICE);

  /// 蜂鸣
  FatVibrationService get vibration => getService<FatVibrationService>(SERVICE_VIBRATION);

  /// 悬浮窗
  FatOverlayManager get overlay => getService<FatOverlayManager>(SERVICE_OVERLAY);

  /// 通知
  FatNotificationManager get notification => getService<FatNotificationManager>(SERVICE_NOTIFICATION);

  bool get isProduct => bool.fromEnvironment("dart.vm.product");

  ThemeData theme;

  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

  Iterable<Locale> supportedLocales;

  InitializeCallback _initializeCallback;

  StateInitializeCallback _stateInitializeCallback;

  List<ChangeNotifierProvider> providers = [];

  List<Permission> _permissions = [];

  List<Permission> get permissions => _permissions;

  set permissions(List<Permission> permissions) {
    _permissions = permissions;
  }

  bool _debug = false;

  bool get debug => _debug;

  set debug(bool value) {
    _debug = value;
  }

  /// 初始化
  initialize() async {
    _serviceLocator = FatServiceLocator();
    _eventBus = EventBus();
    _navigatorKey = GlobalKey();
    _packageInfo = await PackageInfo.fromPlatform();

    await _registerCoreServices();

    await _registerCoreEvents();

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
    // Output
    FatOutputService _output = FatOutputService();
    await _output.initialize();
    await registerService<FatOutputService>(SERVICE_OUTPUT, _output);

    // 路由服务
    FatRouter _router = FatRouter(navigatorKey: _navigatorKey);
    await _router.initialize();
    await registerService<FatRouter>(SERVICE_ROUTER, _router);
    _router.addNavigatorObserver(ApplicationRouterObserver(router: _router));

    // PreferenceManager
    FatPreferenceManager _prefs = FatPreferenceManager();
    await _prefs.initialize();
    await registerService<FatPreferenceManager>(SERVICE_PREFERENCES, _prefs);

    // Toast
    FatToastManager _toast = FatToastManager();
    await _toast.initialize();
    await registerService<FatToastManager>(SERVICE_TOAST, _toast);

    // HTTP
    FatHttpService _http = FatHttpService(output: _output);
    await _http.initialize();
    await registerService<FatHttpService>(SERVICE_HTTP, _http);

    // Loading
    FatLoadingService _loading = FatLoadingService();
    await _loading.initialize();
    await registerService<FatLoadingService>(SERVICE_LOADING, _loading);

    // Upgrader
    FatUpgradeService _upgrader = FatUpgradeService();
    await _upgrader.initialize();
    await registerService<FatUpgradeService>(SERVICE_UPGRADER, _upgrader);

    // Keyboard
    FatKeyboardManager _keyboard = FatKeyboardManager(eventBus: _eventBus);
    await _keyboard.initialize();
    await registerService<FatKeyboardManager>(SERVICE_KEYBOARD, _keyboard);

    // 添加金额键盘
    await _keyboard.addKeyboard(
      inputType: FatMoneyKeyboard.inputType,
      keyboard: FatKeyboard(
        heightGetter: (context) {
          return 240;
        },
        builder: (context, controller) {
          return FatMoneyKeyboard(
            height: 240,
            controller: controller,
            keyboardManager: _keyboard,
          );
        },
      ),
    );

    // Device
    FatDeviceManager _device = FatDeviceManager();
    await _device.initialize();
    await registerService<FatDeviceManager>(SERVICE_DEVICE, _device);

    // 蜂鸣器
    FatVibrationService _vibration = FatVibrationService();
    await _vibration.initialize();
    await registerService<FatVibrationService>(SERVICE_VIBRATION, _vibration);

    // 悬浮窗
    FatOverlayManager _overlay = FatOverlayManager();
    await _overlay.initialize();
    await registerService<FatOverlayManager>(SERVICE_OVERLAY, _overlay);

    // 通知
    FatNotificationManager _notification = FatNotificationManager();
    await registerService<FatNotificationManager>(SERVICE_NOTIFICATION, _notification);
  }

  /// 初始化服务
  initializeServices() async {
    if (_onBeforeInitializeServices != null) {
      await _onBeforeInitializeServices();
    }

    for (final name in _serviceLocator._singletons.keys) {
      final service = _serviceLocator._singletons[name];

      if (!service.initialized) {
        await service.initialize();
      }
    }
  }

  VoidCallback _onBeforeInitializeServices;

  ///
  beforeInitializeServices(VoidCallback callback) {
    _onBeforeInitializeServices = callback;
  }

  /// 注册核心事件
  _registerCoreEvents() {
    _eventBus.on<FatRequestShowKeyboardEvent>().listen((event) {
      _keyboardContainerKey.currentState.show(
        keyboard: event.keyboard,
        controller: event.controller,
      );
    });

    _eventBus.on<FatRequestHideKeyboardEvent>().listen((event) {
      _keyboardContainerKey.currentState.hide();
    });
  }

  /// 注册服务
  registerService<T extends FatService>(String name, T service) {
    _serviceLocator.registerSingleton(name, service);
  }

  /// 获取服务
  T getService<T extends FatService>(String name) {
    return _serviceLocator.getSingleton(name);
  }

  /// 事件监听
  Stream<T> on<T>() {
    return _eventBus.on<T>();
  }

  /// Fires a new event on the event bus with the specified [event].
  void fire(event) {
    _eventBus.fire(event);
  }

  Widget run() {
    return FatKeyboardContainer(
      key: _keyboardContainerKey,
      child: MultiProvider(
        providers: providers,
        child: FatApplicationWrapper(application: this),
      ),
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

    if (widget.application.permissions != null && widget.application.permissions.length > 0) {
      // 请求权限
      await widget.application.permissions.request();
    }
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
      navigatorObservers: widget.application.router.navigatorObservers,
      localizationsDelegates: widget.application.localizationsDelegates,
      supportedLocales: widget.application.supportedLocales,
    );
  }
}
