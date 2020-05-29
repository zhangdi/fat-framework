part of fat_framework;

class FatClickableField<T> extends StatelessWidget {
  final Widget label;
  final String hintText;
  final String errorText;
  final Widget prefix;
  final Widget suffix;
  final T value;
  final VoidCallback onClick;
  final FatValueFormatter<T> formatter;

  FatClickableField({
    Key key,
    @required this.label,
    @required this.onClick,
    this.value,
    this.hintText,
    this.errorText,
    this.formatter,
    this.prefix,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> children = [];

    children.add(prefix);

    final _label = _buildLabel(context);
    if (_label != null) {
      children.add(_label);
      children.add(Divider());
    }

    children.add(_buildValueColumn(context));

    if (suffix == null) {
      children.add(Icon(
        Icons.chevron_right,
        color: theme.textTheme.caption.color,
      ));
    } else {
      children.add(suffix);
    }

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onClick,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children.where((element) => element != null).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildValueColumn(BuildContext context) {
    List<Widget> children = [];

    if (value == null) {
      children.add(_buildHint());
    } else {
      children.add(_buildValue(context));
    }

    if (errorText != null) {
      children.add(_buildError(context));
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.where((element) => element != null).toList(),
      ),
    );
  }

  Widget _buildHint() {
    if (hintText == null) {
      return null;
    } else {
      return Text(
        hintText,
        style: TextStyle(color: kFatPlaceholderColor),
      );
    }
  }

  Widget _buildValue(BuildContext context) {
    final theme = Theme.of(context);

    String value = formatter == null ? '${this.value ?? ""}' : formatter(this.value);

    return DefaultTextStyle(
      style: theme.textTheme.bodyText2.copyWith(
        color: Colors.black,
      ),
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Text(
      errorText,
      style: TextStyle(
        fontSize: 12,
        color: Colors.red,
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    if (label == null) {
      return null;
    }
    final theme = Theme.of(context);

    return Container(
      width: kFatFieldLabelWidth,
      child: DefaultTextStyle(
        style: theme.textTheme.bodyText2.copyWith(color: kFatLabelColor),
        child: label,
      ),
    );
  }
}
