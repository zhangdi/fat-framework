part of fat_framework;

class FatAudioPlayer extends Initialize {
  AudioPlayer audioPlayer;

  /// 播放本地音频
  playLocal(
    String path, {
    double volume = 1.0,
    bool stayAwake = false,
  }) async {
    audioPlayer = await AudioCache().play(path, volume: volume, stayAwake: stayAwake);
  }

  /// 播放网络音频
  playUrl(
    String url, {
    double volume = 1.0,
    bool stayAwake = false,
  }) async {
    audioPlayer = AudioPlayer();

    await audioPlayer.play(url, isLocal: false, volume: volume, stayAwake: stayAwake);
  }

  /// 暂停播放
  pause() async {
    await audioPlayer.pause();
  }

  /// 重新开始
  resume() async {
    await audioPlayer.resume();
  }

  /// 停止播放
  stop() async {
    await audioPlayer.stop();
  }

  /// 释放资源
  release() async {
    await audioPlayer.release();
  }

  /// 销毁
  dispose() async {
    await audioPlayer.dispose();
  }
}
