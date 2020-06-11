part of fat_framework;

class FatTextareaField extends StatelessWidget {
  final TextEditingController controller;
  final Widget label;
  final String hintText;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;
  final String errorText;
  final FormFieldValidator<String> validator;

  FatTextareaField({
    Key key,
    this.controller,
    @required this.label,
    this.hintText,
    this.errorText,
    this.onEditingComplete,
    this.onChanged,
    this.textInputAction,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    final _label = _buildLabel(context);

    if (_label != null) {
      children.add(_label);
      children.add(Divider());
    }

    final _textarea = _buildTextarea(context);
    children.add(_textarea);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextarea(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> children = [];
    children.add(TextFormField(
      controller: controller,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      textInputAction: textInputAction,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        isDense: true,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: theme.textTheme.bodyText2.copyWith(color: kFatPlaceholderColor),
      ),
      buildCounter: (
        BuildContext context, {
        int currentLength,
        int maxLength,
        bool isFocused,
      }) {
        return Text(
          '${currentLength}',
          style: theme.textTheme.caption,
        );
      },
      minLines: 3,
      maxLines: 6,
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
