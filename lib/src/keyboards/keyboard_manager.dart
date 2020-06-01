part of fat_framework;

class FatTextInputType extends TextInputType {
  final String name;
  final String params;

  const FatTextInputType({this.name, bool signed, bool decimal, this.params}) : super.numberWithOptions(signed: signed, decimal: decimal);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'signed': signed, 'decimal': decimal, 'params': params};
  }

  @override
  String toString() {
    return '$runtimeType('
        'name: $name, '
        'signed: $signed, '
        'decimal: $decimal)';
  }

  bool operator ==(Object target) {
    if (target is FatTextInputType) {
      if (this.name == target.toString()) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => this.toString().hashCode;

  factory FatTextInputType.fromJSON(Map<String, dynamic> encoded) {
    return FatTextInputType(name: encoded['name'], signed: encoded['signed'], decimal: encoded['decimal'], params: encoded['params']);
  }
}

typedef FatKeyboardHeightGetter = double Function(BuildContext context);
typedef FatKeyboardBuilder = Widget Function(BuildContext context, FatKeyboardController controller);

class FatKeyboard {
  final FatKeyboardHeightGetter heightGetter;
  final FatKeyboardBuilder builder;

  const FatKeyboard({
    @required this.heightGetter,
    @required this.builder,
  })  : assert(heightGetter != null),
        assert(builder != null);
}

class FatInputClient {
  final int connectionId;
  final TextInputConfiguration configuration;

  const FatInputClient({this.connectionId, this.configuration});

  factory FatInputClient.fromJSON(List<dynamic> encoded) {
    return FatInputClient(
        connectionId: encoded[0],
        configuration: TextInputConfiguration(
            inputType: FatTextInputType.fromJSON(encoded[1]['inputType']),
            obscureText: encoded[1]['obscureText'],
            autocorrect: encoded[1]['autocorrect'],
            actionLabel: encoded[1]['actionLabel'],
            inputAction: _toTextInputAction(encoded[1]['inputAction']),
            textCapitalization: _toTextCapitalization(encoded[1]['textCapitalization']),
            keyboardAppearance: _toBrightness(encoded[1]['keyboardAppearance'])));
  }

  static TextInputAction _toTextInputAction(String action) {
    switch (action) {
      case 'TextInputAction.none':
        return TextInputAction.none;
      case 'TextInputAction.unspecified':
        return TextInputAction.unspecified;
      case 'TextInputAction.go':
        return TextInputAction.go;
      case 'TextInputAction.search':
        return TextInputAction.search;
      case 'TextInputAction.send':
        return TextInputAction.send;
      case 'TextInputAction.next':
        return TextInputAction.next;
      case 'TextInputAction.previuos':
        return TextInputAction.previous;
      case 'TextInputAction.continue_action':
        return TextInputAction.continueAction;
      case 'TextInputAction.join':
        return TextInputAction.join;
      case 'TextInputAction.route':
        return TextInputAction.route;
      case 'TextInputAction.emergencyCall':
        return TextInputAction.emergencyCall;
      case 'TextInputAction.done':
        return TextInputAction.done;
      case 'TextInputAction.newline':
        return TextInputAction.newline;
    }
    throw FlutterError('Unknown text input action: $action');
  }

  static TextCapitalization _toTextCapitalization(String capitalization) {
    switch (capitalization) {
      case 'TextCapitalization.none':
        return TextCapitalization.none;
      case 'TextCapitalization.characters':
        return TextCapitalization.characters;
      case 'TextCapitalization.sentences':
        return TextCapitalization.sentences;
      case 'TextCapitalization.words':
        return TextCapitalization.words;
    }

    throw FlutterError('Unknown text capitalization: $capitalization');
  }

  static Brightness _toBrightness(String brightness) {
    switch (brightness) {
      case 'Brightness.dark':
        return Brightness.dark;
      case 'Brightness.light':
        return Brightness.light;
    }

    throw FlutterError('Unknown Brightness: $brightness');
  }
}

class FatKeyboardMethodChannel {
  static JSONMethodCodec _codec = const JSONMethodCodec();

  static Future<ByteData> sendPlatformMessage(String channel, ByteData message) {
    final Completer<ByteData> completer = Completer<ByteData>();
    window.sendPlatformMessage(channel, message, (ByteData reply) {
      try {
        completer.complete(reply);
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'services library',
          context: ErrorDescription('during a platform message response callback'),
        ));
      }
    });
    return completer.future;
  }

  static sendPerformAction(int connectionId, TextInputAction action) {
    var callbackMethodCall = MethodCall("TextInputClient.performAction", [connectionId, action.toString()]);
    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      "flutter/textinput",
      _codec.encodeMethodCall(callbackMethodCall),
      (data) {},
    );
  }
}

class FatKeyboardManager extends FatService {
  static JSONMethodCodec _codec = const JSONMethodCodec();

  Map<FatTextInputType, FatKeyboard> _keyboards = Map();
  FatInputClient _client;
  String _keyboardParam;
  FatKeyboardController _keyboardController;
  FatKeyboard _currentKeyboard;
  Timer _clearKeyboardTask;
  EventBus eventBus;
  bool _keyboardVisible = false;

  FatKeyboardManager({
    @required this.eventBus,
  }) : assert(eventBus != null);

  @override
  initialize() async {
    inputInterceptor();

    super.initialize();
  }

  /// 输入拦截器
  inputInterceptor() {
    if (initialized) return;

    // 拦截返回
    SystemChannels.navigation.setMethodCallHandler((methodCall) async {
      // POP.
      if (methodCall.method == 'popRoute') {
        if (_keyboardVisible) {
          await hideKeyboard();
          _keyboardVisible = false;
        } else {
          return WidgetsBinding.instance.handlePopRoute();
        }
      }
      // PUSH.
      else if (methodCall.method == 'pushRoute')
        return WidgetsBinding.instance.handlePushRoute(methodCall.arguments);

      // OTHER.
      else
        return Future<dynamic>.value();
    });

    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/textinput',
      (ByteData data) async {
        var methodCall = _codec.decodeMethodCall(data);
        switch (methodCall.method) {
          case 'TextInput.show':
            print('请求显示键盘: TextInput.show');
            if (_currentKeyboard != null) {
              await showKeyboard();

              _keyboardVisible = true;

              return _codec.encodeSuccessEnvelope(null);
            } else {
              return await FatKeyboardMethodChannel.sendPlatformMessage("flutter/textinput", data);
            }
            break;
          case 'TextInput.hide':
            print('请求隐藏键盘');
            if (_currentKeyboard != null) {
              await hideKeyboard();

              _keyboardVisible = false;
              _currentKeyboard = null;
              return _codec.encodeSuccessEnvelope(null);
            } else {
              return await FatKeyboardMethodChannel.sendPlatformMessage("flutter/textinput", data);
            }
            break;
          case 'TextInput.setEditingState':
            print('TextInput.setEditingState');
            if (_client != null) {
              var editingState = TextEditingValue.fromJSON(methodCall.arguments);
              if (editingState != null && _keyboardController != null) {
                _keyboardController.value = editingState;
              }
              return _codec.encodeSuccessEnvelope(null);
            }

            break;
          case 'TextInput.clearClient':
            if (_currentKeyboard != null) {
              return _codec.encodeSuccessEnvelope(null);
            }
            break;
          case 'TextInput.setClient':
            var setInputType = methodCall.arguments[1]['inputType'];

            bool hasCustomKeyboard = false;

            _keyboards.forEach((inputType, keyboard) {
              if (inputType.name == setInputType['name']) {
                hasCustomKeyboard = true;
                _client = FatInputClient.fromJSON(methodCall.arguments);
                _currentKeyboard = keyboard;

                _keyboardController = FatKeyboardController(client: _client)
                  ..addListener(
                    () {
                      var callbackMethodCall = MethodCall("TextInputClient.updateEditingState", [_keyboardController.client.connectionId, _keyboardController.value.toJSON()]);
                      ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage("flutter/textinput", _codec.encodeMethodCall(callbackMethodCall), (data) {});
                    },
                  );
              }
            });

            if (!hasCustomKeyboard) {
              if (_keyboardVisible) {
                hideKeyboard();
              }
              _keyboardVisible = false;
              _client = null;
              _currentKeyboard = null;
            }

            if (_client != null) {
              await FatKeyboardMethodChannel.sendPlatformMessage("flutter/textinput", _codec.encodeMethodCall(MethodCall('TextInput.hide')));
              return _codec.encodeSuccessEnvelope(null);
            }
            break;
        }
        ByteData response = await FatKeyboardMethodChannel.sendPlatformMessage("flutter/textinput", data);
        return response;
      },
    );
  }

  /// 添加键盘
  addKeyboard({
    @required FatTextInputType inputType,
    @required FatKeyboard keyboard,
  }) {
    assert(inputType != null);
    assert(keyboard != null);

    _keyboards[inputType] = keyboard;
  }

  clearKeyboard() {
    _currentKeyboard = null;
    if (_keyboardController != null) {
      _keyboardController.dispose();
      _keyboardController = null;
    }
  }

  showKeyboard() async {
    debugPrint('FatKeyboardManager::showKeyboard');

    print('inputClient: ${_client}');

    /// 发送请求显示键盘事件
    eventBus.fire(FatRequestShowKeyboardEvent(
      client: _client,
      keyboard: _currentKeyboard,
      controller: _keyboardController,
    ));
  }

  hideKeyboard() {
    debugPrint('FatKeyboardManager::hideKeyboard');

    /// 发送请求隐藏键盘事件
    eventBus.fire(FatRequestHideKeyboardEvent());
  }
}
