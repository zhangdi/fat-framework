part of fat_framework;

enum FatFormModelFiledType {
  input,
  picker,
  textarea,
  readonly,
  password,
}

typedef FatFormModelFieldValidator<T> = String Function(T val);
typedef FatFormModelFieldSetter<T> = String Function(T val);
typedef FatFormModelFieldGetter<T> = String Function(T val);

class FatFormModel {
  List<FatFormModelField> _fields = [];

  List<FatFormModelField> get fields => _fields;

  FatFormModel(List<FatFormModelField> fields) {
    this._fields = fields;
  }
  FatFormModelField getField<T>(String name) {
    int i = _fields.indexWhere((FatFormModelField field) => field.name == name);
    if (i == -1) {
      throw Exception('Field ${name} 不存在');
    } else {
      return _fields[i];
    }
  }

  void setField(FatFormModelField field) {
    int i = _fields.indexWhere((FatFormModelField f) => f.name == field.name);
    if (i == -1) {
      throw Exception('Field ${field.name} 不存在');
    } else {
      var _field = _fields[i];

      _field.value = field.value;
      _field.enabled = field.enabled;
    }
  }

  // 验证
  bool validate() {
    bool hasError = false;
    for (FatFormModelField field in _fields) hasError = !field.validate() || hasError;
    return !hasError;
  }

  void save() {
    for (var value in _fields) {
      value.save();
    }
  }

  void reset() {
    for (var value in _fields) {
      value.value = null;
    }
  }

  void setFields(List<FatFormModelField> fields) {
    fields.forEach((field) {
      setField(field);
    });
  }
}

class FatFormModelField<T> {
  String name;
  String label;
  String placeholder;
  bool enabled;
  FatFormModelFiledType type;
  VoidCallback onClick;
  FatFormModelFieldValidator<T> validator;
  FatFormModelFieldSetter<T> onSaved;
  String errorText;
  TextStyle errorStyle = TextStyle(color: Colors.red, fontSize: 12);
  T value;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  Function(BuildContext context) onEditingComplete;
  Widget suffix;

  FatFormModelField({
    @required this.name,
    @required this.label,
    this.type = FatFormModelFiledType.input,
    this.value,
    this.placeholder,
    this.enabled = true,
    this.onClick,
    this.onSaved,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onEditingComplete,
    this.suffix,
  }) {
    if (this.onEditingComplete == null && type == FatFormModelFiledType.input) {
      onEditingComplete = (BuildContext context) {
        FocusScope.of(context).nextFocus();
      };
    }
  }

  bool get hasValue => this.value != null;

  // 验证
  bool validate() {
    if (validator == null) {
      return true;
    } else {
      errorText = validator(value);
      return errorText == null;
    }
  }

  void save() {
    if (onSaved != null) {
      onSaved(value);
    }
  }
}
