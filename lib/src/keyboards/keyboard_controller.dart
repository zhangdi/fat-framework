part of fat_framework;

class FatKeyboardController extends ValueNotifier<TextEditingValue> {
  FatInputClient client;

  FatKeyboardController({
    this.client,
    TextEditingValue value,
  }) : super(value ?? TextEditingValue.empty);

  /// 处理清除
  void clear() {
    value = TextEditingValue.empty;
  }

  /// 处理输入
  void handleInput(String inputText) {
    final oldText = value.text;

    int baseOffset = value.selection.baseOffset;
    int extendOffset = value.selection.extentOffset;

    if (baseOffset == extendOffset) {
      if (baseOffset == -1) {
        baseOffset = extendOffset = 0;
      }

      // 表示从当前位置插入字符
      final startText = oldText.substring(0, baseOffset);
      final endText = oldText.substring(extendOffset, oldText.length);

      final newText = [startText, inputText, endText].join();
      final offset = [startText, inputText].join().length;

      value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: offset),
      );
    } else {
      // 表示替换字符

      // 选中之前的字符
      final startText = oldText.substring(0, baseOffset);
      // 选中之后的字符
      final endText = oldText.substring(extendOffset, oldText.length);

      final newText = [startText, inputText, endText].join();

      final offset = [startText, inputText].join().length;

      value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: offset),
      );
    }
  }

  /// 处理删除
  void handleDelete() {
    final oldText = value.text;

    int baseOffset = value.selection.baseOffset;
    int extendOffset = value.selection.extentOffset;

    if (baseOffset == extendOffset) {
      if (baseOffset <= 0) {
        return;
      }

      // 表示从当前位置删除一个字符
      final startText = oldText.substring(0, baseOffset);
      final endText = oldText.substring(extendOffset, oldText.length);

      final offset = baseOffset - 1;
      final newText = [startText.substring(0, offset), endText].join();

      value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: offset),
      );
    } else {
      // 选中之前的字符
      final startText = oldText.substring(0, baseOffset);
      // 选中之后的字符
      final endText = oldText.substring(extendOffset, oldText.length);

      final newText = [startText, endText].join();

      final offset = startText.length;

      value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: offset),
      );
    }
  }

  void actionDone() {
    FatKeyboardMethodChannel.sendPerformAction(client.connectionId, TextInputAction.done);
  }

  void actionNext() {
    FatKeyboardMethodChannel.sendPerformAction(client.connectionId, TextInputAction.next);
  }
}
