part of fat_framework;

class FatUrlUtil {
  ///
  static String buildUrlParams(Map<String, dynamic> params) {
    if (params == null || params.length == 0) {
      return null;
    }
    List<String> pairs = [];

    params.forEach((key, value) {
      pairs.add('${key}=${value}');
    });

    return pairs.join('&');
  }
}
