part of fat_framework;

///
typedef Widget FatPageBuilder(BuildContext context, FatRouteArguments arguments);

/// 路由处理器
class FatRouteHandler {
  final FatPageBuilder builder;

  FatRouteHandler({@required this.builder});
}

/// 路由
class FatRoute {
  String path;
  FatRouteArguments arguments;
  Map<String, dynamic> meta;
  FatRouteHandler handler;

  FatRoute({
    @required this.path,
    @required this.handler,
    this.arguments,
    this.meta = const {},
  });
}

class FatRouteArguments {
  Map<String, Object> _arguments;

  FatRouteArguments(Map<String, Object> arguments) {
    if (arguments == null) {
      _arguments = Map();
    } else {
      _arguments = arguments;
    }
  }

  ///
  void set<T extends Object>(String name, T value) {
    _arguments[name] = value;
  }

  ///
  T get<T extends Object>(String name, {T defaultValue}) {
    if (_arguments.containsKey(name)) {
      return _arguments[name];
    } else {
      return defaultValue;
    }
  }

  @override
  String toString() {
    return _arguments.toString();
  }
}

/// 路由拦截器
class FatRouteInterceptor {
  bool Function(String path, FatRouteArguments arguments) beforePush;

  FatRouteInterceptor({this.beforePush});
}

///
class FatRouter extends FatService {
  GlobalKey<NavigatorState> navigatorKey;
  List<FatRouteInterceptor> _interceptors = List();

  Route<dynamic> currentRoute;

  List<FatRoute> _routes = List<FatRoute>();

  ///
  FatRouteHandler notFoundHandler;

  FatRouter({
    @required this.navigatorKey,
  }) : assert(navigatorKey != null);

  @override
  initialize() async {
    super.initialize();
  }

  ///
  List<NavigatorObserver> getNavigatorObservers() {
    return [
      ApplicationRouterObserver(router: this),
    ];
  }

  ///
  bool _beforePush(String path, FatRouteArguments arguments) {
    bool result = true;

    for (var value in _interceptors) {
      if (value.beforePush != null) {
        result = result && value.beforePush(path, arguments);
      }
    }

    return result;
  }

  /// 添加路由拦截器
  void addInterceptor(FatRouteInterceptor interceptor) {
    _interceptors.add(interceptor);
  }

  ///
  void pop<T extends Object>([T result]) {
    navigatorKey.currentState?.pop(result);
  }

  ///
  void popUntil(RoutePredicate predicate) {
    navigatorKey.currentState?.popUntil(predicate);
  }

  ///
  Future<T> popAndPushNamed<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Map<String, dynamic> arguments,
  }) {
    final _arguments = FatRouteArguments(arguments);

    if (_beforePush(routeName, _arguments)) {
      return navigatorKey.currentState?.popAndPushNamed(routeName, result: result, arguments: _arguments);
    }
  }

  ///
  Future<T> push<T extends Object>(String routeName, {Map<String, dynamic> arguments}) async {
    final _arguments = FatRouteArguments(arguments);
    if (_beforePush(routeName, _arguments)) {
      return await navigatorKey.currentState?.pushNamed<T>(routeName, arguments: _arguments);
    }
  }

  ///
  Future<T> pushAndRemoveUntil<T extends Object>(
    String path,
    RoutePredicate predicate, {
    Map<String, dynamic> arguments,
  }) async {
    final _arguments = FatRouteArguments(arguments);
    if (_beforePush(path, _arguments)) {
      return await navigatorKey.currentState?.pushNamedAndRemoveUntil(path, predicate, arguments: _arguments);
    }
  }

  Future<T> pushReplacement<T extends Object, TO extends Object>(
    String routeName, {
    TO result,
    Map<String, dynamic> arguments,
  }) {
    final _arguments = FatRouteArguments(arguments);

    if (_beforePush(routeName, _arguments)) {
      return navigatorKey.currentState?.pushReplacementNamed(routeName, result: result, arguments: _arguments);
    }
  }

  /// 定义路由
  define(String path, {@required FatRouteHandler handler}) {
    _routes.add(FatRoute(path: path, handler: handler));
  }

  /// 添加路由
  addRoute(FatRoute route) {
    _routes.add(route);
  }

  ///
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final index = _routes.indexWhere((element) => element.path == settings.name);

    if (index == -1) {
      if (notFoundHandler != null) {
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return notFoundHandler.builder(context, settings.arguments);
          },
          settings: settings,
        );
      } else {
        debugPrint('Unhandled not found route');
      }
    } else {
      final handler = _routes[index].handler;
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return handler.builder(context, settings.arguments);
        },
        settings: settings,
      );
    }
  }

  // 注册路由
  void registerRoute({@required String path, @required FatRouteHandler handler}) {
    addRoute(FatRoute(path: path, handler: handler));
  }
}

/// 路由观察者
class ApplicationRouterObserver extends NavigatorObserver {
  FatRouter router;

  ApplicationRouterObserver({
    @required this.router,
  }) : assert(router != null);

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    this.router.currentRoute = route;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    this.router.currentRoute = previousRoute;
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {}

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {}
}

/// 判断是否为活跃路由
bool isRouteActive(FatRouter router, String name, bool test(FatRouteArguments arguments)) {
  if (router.currentRoute == null) {
    return false;
  }
  if (router.currentRoute.settings.name != name) {
    return false;
  }

  return test(router.currentRoute.settings.arguments);
}
