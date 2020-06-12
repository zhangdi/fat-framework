part of fat_framework;

class FatNotificationManager extends FatService {
  FlutterLocalNotificationsPlugin _notificationPlugin;
  SelectNotificationCallback _onSelectNotification;

  String _defaultIcon = 'ic_launcher';

  @override
  Future<void> initialize() async {
    _notificationPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings(_defaultIcon);
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    await _notificationPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
  }

  /// 设置点击通知回调，必须在 [initialize] 之前调用
  set onSelectNotification(SelectNotificationCallback onSelectNotification) {
    _onSelectNotification = onSelectNotification;
  }

  /// 设置通知图标，必须在 [initialize] 之前调用
  set defaultIcon(String defaultIcon){
    _defaultIcon = defaultIcon;
  }

  void show(FatNotification notification) async {
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', importance: Importance.Max, priority: Priority.High, ticker: 'ticker');

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _notificationPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: notification.payload,
    );
  }
}
