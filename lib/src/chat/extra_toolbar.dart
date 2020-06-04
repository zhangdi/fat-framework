part of fat_framework;

class FatChatExtraToolbar extends StatelessWidget {
  final List<Widget> items;
  ThemeData mTheme;

  FatChatExtraToolbar({@required this.items});

  @override
  Widget build(BuildContext context) {
    mTheme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: kFatChatExtraToolbarHeight,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: mTheme.dividerColor, width: 1)),
        color: mTheme.scaffoldBackgroundColor,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        children: items,
      ),
    );
  }
}
