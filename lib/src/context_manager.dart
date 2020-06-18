part of fat_framework;

class FatContextManager extends FatService {
  List<BuildContext> _contexts;

  @override
  initialize() async {
    _contexts = List<BuildContext>();

    await super.initialize();
  }

  void push(BuildContext context) {
    _contexts.insert(0, context);
  }

  void pop(BuildContext context) {
    _contexts.remove(context);
  }

  BuildContext get current => _contexts[0];
}
