part of fat_framework;

class FatServiceLocator {
  Map<String, FatService> _singletons = new Map();

  FatServiceLocator({Map<String, FatService> services}) : _singletons = services ?? Map<String, FatService>();

  /// 注册单例
  registerSingleton<T extends FatService>(String serviceName, T service) {
    _registerSingleton(serviceName, service);
  }

  ///
  _registerSingleton<T extends FatService>(String serviceName, T service) {
    _singletons[serviceName] = service;
  }

  ///
  getSingleton(String serviceName) {
    if (_singletons.containsKey(serviceName)) {
      return _singletons[serviceName];
    } else {
      throw new FatServiceLocatorException('Not found service: ${serviceName}');
    }
  }
}

class FatServiceLocatorException implements Exception {
  final String message;

  FatServiceLocatorException(this.message);
}
