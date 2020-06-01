part of fat_framework;

/// 请求显示键盘
class FatRequestShowKeyboardEvent {
  FatInputClient client;
  FatKeyboard keyboard;
  FatKeyboardController controller;
  VoidCallback onHide;

  FatRequestShowKeyboardEvent({
    @required this.client,
    @required this.keyboard,
    this.controller,
    this.onHide,
  })  : assert(client != null),
        assert(keyboard != null);
}

class FatRequestHideKeyboardEvent {}
