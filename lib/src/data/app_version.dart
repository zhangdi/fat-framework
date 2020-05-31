part of fat_framework;

class FatAppVersion {
  final String name;
  final String packageName;
  final int versionCode;
  final String versionName;
  final String contents;
  final bool force;
  final String downloadUrl;
  final int fileSize;
  final String fileMd5;
  final int releaseAt;

  FatAppVersion({
    this.name,
    this.packageName,
    this.versionCode,
    this.versionName,
    this.contents,
    this.force,
    this.downloadUrl,
    this.fileSize,
    this.fileMd5,
    this.releaseAt,
  });
}
