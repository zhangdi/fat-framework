part of fat_framework;

Future<T> showModalBottomListSheet<T>({
  @required BuildContext context,
  @required Widget title,
  @required List<T> items,
  FatValueWidgetFormatter<T> displayFormatter,
}) async {
  hideKeyboard(context);
  final theme = Theme.of(context);

  return await showModalBottomSheet<T>(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      enableDrag: false,
      builder: (BuildContext context) {
        List<Widget> children = [];
        double titleHeight = 48;
        double footerHeight = 48;

        if (title != null) {
          children.add(
            Positioned(
              top: 0,
              right: 0,
              height: titleHeight,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: theme.dividerColor, width: 1),
                  ),
                ),
                height: titleHeight,
                alignment: Alignment.center,
                child: DefaultTextStyle(
                  style: theme.textTheme.subtitle1,
                  child: title,
                ),
              ),
            ),
          );
        }

        children.add(
          Positioned(
            top: titleHeight,
            right: 0,
            bottom: footerHeight + 16,
            left: 0,
            child: items == null || items.length == 0
                ? Container()
                : ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      final item = items[index];
                      return Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(item);
                          },
                          child: displayFormatter == null
                              ? ListTile(
                                  title: Text('${item}'),
                                )
                              : displayFormatter(item),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    itemCount: items.length),
          ),
        );

        children.add(
          Positioned(
            right: 0,
            bottom: 0,
            left: 0,
            height: footerHeight,
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text(
                    '取消',
                    style: theme.textTheme.subtitle1,
                  ),
                ),
              ),
            ),
          ),
        );

        return Stack(
          fit: StackFit.loose,
          children: children,
        );
      });
}
