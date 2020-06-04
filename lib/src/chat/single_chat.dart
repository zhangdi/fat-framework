part of fat_framework;

class FatSingleChat extends StatelessWidget {
  final List<Widget> extraToolbarChildren;
  final FatSingleChatController controller;
  final SendTextCallback onSendText;
  final PreferredSizeWidget appBar;

  FatSingleChat({
    Key key,
    this.extraToolbarChildren,
    @required this.controller,
    @required this.appBar,
    this.onSendText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: this.controller),
      ],
      child: FatSingleChatModule(
        appBar: appBar,
        extraToolbarChildren: extraToolbarChildren,
        onSendText: onSendText,
      ),
    );
  }
}

class FatSingleChatModule extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final List<Widget> extraToolbarChildren;
  final SendTextCallback onSendText;
  final SendPicCallback onSendPic;

  FatSingleChatModule({@required this.appBar, this.extraToolbarChildren, this.onSendText, this.onSendPic});

  @override
  FatSingleChatModuleState createState() => FatSingleChatModuleState();
}

class FatSingleChatModuleState extends State<FatSingleChatModule> {
  FatSingleChatController mProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mProvider = Provider.of<FatSingleChatController>(context);

    return Scaffold(
      appBar: widget.appBar,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    List<Widget> children = [];

    children.add(_buildToolbar());

    children.add(_buildMessages());

    return Stack(
      fit: StackFit.expand,
      children: children,
    );
  }

  //<editor-fold desc="工具栏">
  Widget _buildToolbar() {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      height: mProvider.toolbarHeight,
      child: FatChatToolbar(
        extraToolbarChildren: widget.extraToolbarChildren ?? [],
        onSendText: widget.onSendText,
        onExtraToolbarVisibleChanged: (bool visible) {
          if (visible) {
            mProvider.toolbarHeight = kFatChatToolbarHeight + kFatChatExtraToolbarHeight;
          } else {
            mProvider.toolbarHeight = kFatChatToolbarHeight;
          }
        },
      ),
    );
  }

  //</editor-fold>

  //<editor-fold desc="消息列表">
  Widget _buildMessages() {
    return Positioned(
      top: 0,
      right: 0,
      bottom: mProvider.toolbarHeight,
      left: 0,
      child: ListView.builder(
        reverse: true,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        controller: mProvider.scrollController,
        itemBuilder: (BuildContext context, int index) {
          return mProvider.messages.reversed.toList()[index];
        },
        itemCount: mProvider.messages.length,
      ),
    );
  }
//</editor-fold>
}
