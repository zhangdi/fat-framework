part of fat_framework;

class FatToastManager extends FatService {
  // 显示 Toast
  void show(
    BuildContext context,
    String message, {
    int duration = 1,
    int gravity = 0,
    Color backgroundColor = const Color(0xAA000000),
    Color textColor = Colors.white,
    double backgroundRadius = 20,
    Border border,
  }) {
    Toast.show(
      message,
      context,
      duration: duration,
      gravity: gravity,
      backgroundColor: backgroundColor,
      backgroundRadius: backgroundRadius,
      border: border,
    );
  }
}
