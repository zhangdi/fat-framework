part of fat_framework;

/// 隐藏软键盘
void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
