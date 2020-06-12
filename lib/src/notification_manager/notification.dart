part of fat_framework;

class FatNotification {
  final int id;
  final String title;
  final String body;
  String payload;

  FatNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    this.payload,
  })  : assert(id != null),
        assert(title != null),
        assert(body != null);
}
