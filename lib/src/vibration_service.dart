part of fat_framework;

class FatVibrationService extends FatService {
  /// 是否有蜂鸣器
  Future<bool> hasVibrator() async {
    return await Vibration.hasVibrator();
  }

  /// 震动
  vibrate({int duration = 500, List<int> pattern = const [], int repeat = -1, List<int> intensities = const [], int amplitude = -1}) async {
    await Vibration.vibrate(
      duration: duration,
      pattern: pattern,
      repeat: repeat,
      intensities: intensities,
      amplitude: amplitude,
    );
  }

  /// 是否有振幅控制
  Future<bool> hasAmplitudeControl() async {
    return await Vibration.hasAmplitudeControl();
  }

  /// 取消
  cancel() async {
    await Vibration.cancel();
  }
}
