part of fat_framework;

class FatReadonlyField<T> extends StatelessWidget {
  final TextEditingController controller;
  final Widget label;
  final String hintText;
  final String errorText;
  final Widget prefix;
  final Widget suffix;
  final Widget value;

  FatReadonlyField({
    Key key,
    this.controller,
    @required this.label,
    @required this.value,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(prefix);

    final _label = _buildLabel(context);
    if (_label != null) {
      children.add(_label);
      children.add(FatSpace(width: 16,));
    }

    final _input = _buildInput(context);
    children.add(_input);

    children.add(suffix);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: 48,
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children.where((element) => element != null).toList(),
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> children = [];
    children.add(DefaultTextStyle(
      style: theme.textTheme.bodyText2.copyWith(color: kFatPlaceholderColor),
      child: value,
    ));

    if (errorText != null) {
      children.add(_buildError(context));
    }

    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
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
