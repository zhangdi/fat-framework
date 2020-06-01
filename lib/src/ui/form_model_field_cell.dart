part of fat_framework;

class FatFormModelFieldCell extends StatefulWidget {
  FatFormModelField field;
  FatValueFormatter formatter;

  FatFormModelFieldCell(this.field, {this.formatter});

  @override
  _FatFormModelFieldCellState createState() => _FatFormModelFieldCellState();
}

class _FatFormModelFieldCellState extends State<FatFormModelFieldCell> {
  @override
  Widget build(BuildContext context) {
    switch (widget.field.type) {
      case FatFormModelFieldType.input:
        return _buildInputField(context);
        break;
      case FatFormModelFieldType.picker:
        return _buildPicker(context);
        break;
      case FatFormModelFieldType.textarea:
        return _buildTextareaField(context);
        break;
      case FatFormModelFieldType.readonly:
        return _buildReadonlyField(context);
        break;
      case FatFormModelFieldType.password:
        return _buildPasswordField(context);
        break;
    }
  }

  Widget _buildReadonlyField(BuildContext context) {
    return FatReadonlyField(
      label: Text(widget.field.label),
      value: Text(formatValue(widget.field.value)),
    );
  }

  Widget _buildTextareaField(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    editingController.text = widget.field.hasValue ? widget.field.value : '';
    return FatTextareaField(
      controller: editingController,
      label: Text(widget.field.label),
      hintText: widget.field.placeholder,
      textInputAction: widget.field.textInputAction,
      errorText: widget.field.errorText,
      onChanged: (String val) {
        widget.field.value = val;
      },
      onEditingComplete: () {
        if (widget.field.onEditingComplete != null) {
          widget.field.onEditingComplete(context);
        }
      },
    );
  }

  Widget _buildError(BuildContext context) {
    if (widget.field.errorText == null) {
      return null;
    } else {
      return Text(
        widget.field.errorText,
        style: widget.field.errorStyle,
      );
    }
  }

  String formatValue(val) {
    if (widget.formatter == null) {
      return val.toString();
    } else {
      return widget.formatter(val);
    }
  }

  Widget _buildInputField(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    editingController.text = widget.field.hasValue ? widget.field.value : '';

    return FatInputField(
      controller: editingController,
      label: Text(widget.field.label),
      hintText: widget.field.placeholder,
      textInputAction: widget.field.textInputAction,
      errorText: widget.field.errorText,
      suffix: widget.field.suffix,
      keyboardType: widget.field.keyboardType,
      onChanged: (String val) {
        widget.field.value = val;
      },
      onEditingComplete: () {
        if (widget.field.onEditingComplete != null) {
          widget.field.onEditingComplete(context);
        }
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    editingController.text = widget.field.hasValue ? widget.field.value : '';

    return FatInputField(
      controller: editingController,
      label: Text(widget.field.label),
      hintText: widget.field.placeholder,
      textInputAction: widget.field.textInputAction,
      errorText: widget.field.errorText,
      suffix: widget.field.suffix,
      keyboardType: widget.field.keyboardType,
      obscureText: true,
      onChanged: (String val) {
        widget.field.value = val;
      },
      onEditingComplete: () {
        if (widget.field.onEditingComplete != null) {
          widget.field.onEditingComplete(context);
        }
      },
    );
  }

  Widget _buildPicker(BuildContext context) {
    return FatClickableField(
      label: Text(widget.field.label),
      value: widget.field.hasValue ? formatValue(widget.field.value) : null,
      onClick: widget.field.onClick,
      hintText: widget.field.placeholder,
      errorText: widget.field.errorText,
    );
  }
}
