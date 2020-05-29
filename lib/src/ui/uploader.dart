part of fat_framework;

typedef FatUploadHandler = Future<String> Function(File file);

class FatUploader extends StatefulWidget {
  final Widget title;
  final ValueChanged<List<String>> onChanged;
  final FatUploadHandler uploadHandler;
  final List<String> urls;
  final bool removable;

  FatUploader({
    Key key,
    this.onChanged,
    this.title,
    this.uploadHandler,
    this.urls = const [],
    this.removable = true,
  })  : assert(uploadHandler != null),
        super(key: key);

  @override
  FatUploaderState createState() => FatUploaderState();
}

class FatUploaderState extends State<FatUploader> {
  List<String> _urls = [];
  Map<String, Widget> _items = Map();
  int _index = 0;

  List<String> get urls => _urls;

  @override
  void initState() {
    super.initState();
    _urls = widget.urls.toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<Widget> items = [];

    _items.forEach((String name, Widget element) {
      items.add(element);
    });

    if (widget.uploadHandler != null) {
      items.add(_buildUploadItem());
    }

    List<Widget> children = [];

    if (widget.title != null) {
      children.add(Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: theme.dividerTheme.thickness,
            ),
          ),
        ),
        child: DefaultTextStyle(
          style: theme.textTheme.bodyText2.copyWith(
            color: Colors.grey,
          ),
          child: widget.title,
        ),
      ));
    }

    children.add(Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      color: Colors.white,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 4,
        children: items,
      ),
    ));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildUploadItem() {
    return _buildItem(
      child: Material(
        color: Colors.grey[200],
        child: InkWell(
          onTap: () async {
            ImageSource imageSource = await showModalBottomListSheet<ImageSource>(
              context: context,
              title: Text('上传图片'),
              items: [ImageSource.gallery, ImageSource.camera],
              displayFormatter: (ImageSource val) {
                switch (val) {
                  case ImageSource.camera:
                    return ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('拍照上传'),
                    );
                    break;
                  case ImageSource.gallery:
                    return ListTile(
                      leading: Icon(Icons.image),
                      title: Text('从相册上传'),
                    );
                    break;
                  default:
                    return Container();
                }
              },
            );

            if (imageSource != null) {
              ImagePicker.pickImage(source: imageSource).then((value) {
                if (value != null) {
                  _onImagePicked(value);
                }
              });
            }
          },
          child: Icon(
            AntDesign.plus,
            color: Colors.grey[600],
            size: 40,
          ),
        ),
      ),
    );
  }

  _onImagePicked(File file) {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        String name = 'item-${_index}';
        _items[name] = _buildUploadingItem(name, file);
        _index++;
      });
    });
  }

  Widget _buildUrlItem(String name, String url) {
    return _buildItem(
      child: _buildNetworkImage(url),
      onRemove: () {
        setState(() {
          _items.removeWhere((key, value) => key == name);
        });
      },
    );
  }

  Widget _buildNetworkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (BuildContext context, String url) {
        return Container(
          color: Colors.grey[200],
        );
      },
    );
  }

  Widget _buildUploadingItem(String name, File file) {
    Future<String> future = widget.uploadHandler(file);
    return _buildItem(
      onRemove: () {
        setState(() {
          _items.removeWhere((key, value) => key == name);
        });
      },
      child: FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Widget> children = [
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: Image.file(
                file,
                fit: BoxFit.cover,
              ),
            ),
          ];

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              children.add(Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Feather.alert_circle,
                          color: Colors.white,
                        ),
                        FatSpace(
                          height: 2,
                        ),
                        Text(
                          '上传失败',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ));
            } else {
              // 上传成功

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  addUrl(snapshot.data);

                  _items.removeWhere((key, value) => key == name);
                  _items[name] = _buildUrlItem(name, snapshot.data);
                });
              });
            }
          } else {
            children.add(Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              ),
            ));
          }

          return Stack(
            children: children,
          );
        },
      ),
    );
  }

  void addUrl(String url) {
    if (_urls.indexOf(url) == -1) {
      _urls.add(url);
    }

    if (widget.onChanged != null) {
      widget.onChanged(_urls);
    }
  }

  void removeUrl(String url) {
    _urls.remove(url);

    if (widget.onChanged != null) {
      widget.onChanged(_urls);
    }
  }

  Widget _buildItem({@required Widget child, VoidCallback onRemove}) {
    List<Widget> children = [];

    children.add(Positioned(
      top: 12,
      right: 12,
      bottom: 12,
      left: 12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    ));

    if (widget.removable && onRemove != null) {
      children.add(Positioned(
        top: 0,
        right: 0,
        width: 24,
        height: 24,
        child: _buildRemovable(onRemove, size: 24),
      ));
    }

    return Stack(
      children: children,
    );
  }

  _buildRemovable(VoidCallback onRemove, {double size = 20}) {
    double gutter = 1;
    final borderRadius = BorderRadius.circular(size);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('确定删除？'),
                  actions: <Widget>[
                    FatButton(
                      type: FatButtonType.light,
                      child: Text('取消'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FatButton(
                      child: Text('确定删除'),
                      onPressed: () {
                        hideKeyboard(context);
                        onRemove();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
        child: Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(gutter),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
          ),
          child: Container(
            width: size - gutter * 2,
            height: size - gutter * 2,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: borderRadius,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: size * 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
