part of fat_framework;

class FatSingleChatController extends ChangeNotifier {
  double _toolbarHeight = kFatChatToolbarHeight;

  double get toolbarHeight => _toolbarHeight;

  set toolbarHeight(double value) {
    _toolbarHeight = value;
    notifyListeners();
  }

  //<editor-fold desc="滚动相关">
  ScrollController scrollController = ScrollController();

  /// 滚动到底部
  void scrollToBottom() {
    scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  //</editor-fold>

  //<editor-fold desc="消息相关">
  List<FatChatMessage> _messages = [];

  List<FatChatMessage> get messages => _messages;

  ///
  void pushMessage(FatChatMessage message) {
    _messages.add(message);

    notifyListeners();
  }
//</editor-fold>
}
