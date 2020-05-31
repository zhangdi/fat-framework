part of fat_framework;

abstract class FatForm extends StatefulWidget {
  FatForm({Key key}) : super(key: key);

  @override
  FatFormState createState();
}

abstract class FatFormState<T extends FatForm> extends State<T> {
  @protected
  FatFormModel mFormModel;

  @override
  void initState() {
    super.initState();

    initFormModel();
  }

  /// 初始化 FormModel
  void initFormModel();

  /// 验证
  bool validate() {
    final rs = mFormModel.validate();
    setState(() {});

    return rs;
  }

  /// 保存
  void save() {
    mFormModel.save();
  }

  /// 重置
  void reset() {
    setState(() {
      mFormModel.reset();
    });
  }
}
