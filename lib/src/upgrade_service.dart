part of fat_framework;

class FatUpgradeService extends FatService {
  UpgradeCheckHandler _upgradeCheckHandler;

  UpgradeCheckHandler get upgradeCheckHandler => _upgradeCheckHandler;

  set upgradeCheckHandler(UpgradeCheckHandler value) {
    _upgradeCheckHandler = value;
  }

  UpgradeHandler _upgradeHandler;

  UpgradeHandler get upgradeHandler => _upgradeHandler;

  set upgradeHandler(UpgradeHandler value) {
    _upgradeHandler = value;
  }

  /// 检查是否有新版本
  check(BuildContext context, {bool showTip = false}) async {
    assert(_upgradeCheckHandler != null);
    assert(_upgradeHandler != null);

    if (Platform.isAndroid) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int currentVersionCode = int.parse(packageInfo.buildNumber);

      FatAppVersion latestVersion = await _upgradeCheckHandler();

      if (latestVersion != null) {
        if (currentVersionCode < latestVersion.versionCode) {
          // 有最新版本
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                List<Widget> actions = [];

                if (!latestVersion.force) {
                  actions.add(FatButton(
                    child: Text('取消'),
                    type: FatButtonType.light,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ));
                }

                actions.add(FatButton(
                  child: Text('立即更新'),
                  type: FatButtonType.primary,
                  onPressed: () async {
                    final rs = await _upgradeHandler(latestVersion);

                    if (!latestVersion.force && rs) {
                      Navigator.of(context).pop();
                    }
                  },
                ));

                return WillPopScope(
                  onWillPop: () async {
                    return !latestVersion.force;
                  },
                  child: AlertDialog(
                    title: Text('有新版本了'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            latestVersion.versionName,
                            style: TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),
                          ),
                          FatSpace(
                            height: 16,
                          ),
                          Text(
                            latestVersion.contents ?? '',
                            style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
                          )
                        ],
                      ),
                    ),
                    actions: actions,
                  ),
                );
              });
        } else {
          if (showTip) {
            Toast.show('已经是最新版', context);
          }
        }
      }
    }
  }
}
