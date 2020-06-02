part of fat_framework;

class FatCellTitle extends StatelessWidget {
  final Widget title;
  final Color color;

  const FatCellTitle({
    @required this.title,
    this.color = Colors.white,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 14,
          color: Colors.black.withOpacity(0.5),
        ),
        child: title,
      ),
    );
  }
}

class FatCell extends StatelessWidget {
  final Widget prefix;
  final Widget suffix;
  final Widget title;
  final Widget value;
  final Widget desc;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  final Color color;
  final Alignment alignment;

  FatCell({
    @required this.title,
    this.value,
    this.onPressed,
    this.onLongPressed,
    this.desc,
    this.prefix,
    this.suffix,
    this.color = Colors.white,
    this.alignment = Alignment.centerLeft,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.subtitle1;
    TextStyle valueStyle = theme.textTheme.bodyText2.copyWith(color: Colors.grey);

    Widget titleWidget = DefaultTextStyle(
      style: titleStyle,
      child: title,
    );

    return Material(
      color: color,
      child: InkWell(
        onTap: onPressed,
        onLongPress: onLongPressed,
        child: Container(
          constraints: BoxConstraints(
            minHeight: 48,
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              prefix == null
                  ? null
                  : Container(
                      margin: EdgeInsets.only(right: 16),
                      child: IconTheme(
                        data: IconThemeData(),
                        child: prefix,
                      ),
                    ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: alignment,
                      child: titleWidget,
                    ),
                    desc == null
                        ? null
                        : Container(
                            child: DefaultTextStyle(
                              style: theme.textTheme.caption,
                              child: desc,
                            ),
                          )
                  ].where((element) => element != null).toList(),
                ),
              ),
              value == null
                  ? null
                  : DefaultTextStyle(
                      style: valueStyle,
                      child: value,
                    ),
              suffix == null
                  ? null
                  : Container(
                      margin: EdgeInsets.only(left: 8),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.grey),
                        child: suffix,
                      ),
                    ),
            ].where((e) => e != null).toList(),
          ),
        ),
      ),
    );
  }
}

class FatCellComment extends StatelessWidget {
  final Widget comment;

  const FatCellComment({
    @required this.comment,
  }) : assert(comment != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 12,
          color: Colors.black.withOpacity(0.5),
        ),
        child: comment,
      ),
    );
  }
}
