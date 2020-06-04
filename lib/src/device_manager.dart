part of fat_framework;

class FatDeviceInfo {
  FatDeviceInfo({
    this.id,
    this.name,
    this.osName,
    this.osVersion,
    this.model,
    this.brand,
  });

  /// 设备ID
  final String id;

  ///
  final String name;

  /// 操作系统名称
  final String osName;

  /// 操作系统版本
  final String osVersion;

  /// 型号
  final String model;

  /// 品牌
  final String brand;
}

class FatDeviceManager extends FatService {
  DeviceInfoPlugin _deviceInfoPlugin;
  IosDeviceInfo _iosDeviceInfo;
  AndroidDeviceInfo _androidDeviceInfo;

  @override
  initialize() async {
    _deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      _iosDeviceInfo = await _deviceInfoPlugin.iosInfo;
    } else if (Platform.isAndroid) {
      _androidDeviceInfo = await _deviceInfoPlugin.androidInfo;
    }

    super.initialize();
  }

  ///
  String getUUID() {
    if (Platform.isIOS) {
      return _iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      return _androidDeviceInfo.androidId; // unique ID on Android
    }

    return null;
  }

  /// 获取设备信息
  FatDeviceInfo getDeviceInfo() {
    if (Platform.isIOS) {
      return FatDeviceInfo(
          id: _iosDeviceInfo.identifierForVendor,
          name: _iosDeviceInfo.name,
          osName: _iosDeviceInfo.systemName,
          osVersion: _iosDeviceInfo.systemVersion,
          model: _iosDeviceInfo.model,
          brand: 'Apple'); // unique ID on iOS
    } else if (Platform.isAndroid) {
      return FatDeviceInfo(
        id: _androidDeviceInfo.androidId,
        name: _androidDeviceInfo.model,
        osName: 'Android',
        osVersion: _androidDeviceInfo.version.release,
        model: _androidDeviceInfo.model,
        brand: _androidDeviceInfo.brand,
      ); // un/ unique ID on Android
    }

    return null;
  }
}
