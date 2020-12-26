import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/services/app_info_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPageContentDesktop extends StatelessWidget {
  final int currentIndex;
  final List<Widget> pages;
  final void Function(int) navigateTo;
  final VoidCallback onFilter;

  MainPageContentDesktop({
    Key key,
    this.currentIndex,
    this.pages,
    this.navigateTo,
    this.onFilter,
  })  : assert(currentIndex != null && currentIndex >= 0),
        assert(pages != null && pages.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: [
          Placeholder(
            fallbackWidth: 48.0,
            fallbackHeight: 48.0,
          ),
          SizedBox(width: 16.0),
          Text(locator<AppInfoService>().appName),
        ],
        actions: [
          if (currentIndex == 0)
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: onFilter,
            ),
        ],
        onTap: navigateTo,
        selectedIndex: currentIndex,
      ),
      body: IndexedStack(
        children: pages,
        index: currentIndex,
      ),
    );
  }
}

/// Widget that implements a custom AppBar with [leading] icon and title,
/// some [actions] and a central menu.
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Title displayed on the left.
  final List<Widget> leading;

  /// Actions on the right.
  final List<Widget> actions;

  /// Current selected menu item.
  final int selectedIndex;

  /// Callback called when a menu item is pressed.
  final Function(int) onTap;

  CustomAppBar({
    this.leading,
    this.actions,
    this.selectedIndex,
    this.onTap,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;

    final IconThemeData actionsIconTheme =
        appBarTheme.actionsIconTheme ?? theme.primaryIconTheme;
    final TextStyle titleTextStyle =
        theme.textTheme.headline6.copyWith(color: Colors.white);

    // Title widget
    Widget titleWidget = Align(
      alignment: Alignment.centerLeft,
      child: DefaultTextStyle(
        style: titleTextStyle,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: Row(children: widget.leading),
      ),
    );

    // Center widget
    Widget middleNavigation = Container(
      width: 600.0,
      height: double.maxFinite,
      child: TabBar(
        controller: TabController(
          length: 3,
          initialIndex: widget.selectedIndex,
          vsync: this,
        ),
        indicatorPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white,
              width: 3.0,
            ),
          ),
        ),
        tabs: [
          Tab(
            icon: Icon(
              Icons.home,
              color: widget.selectedIndex == 0 ? Colors.white : Colors.black45,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.add_circle_outline,
              color: widget.selectedIndex == 1 ? Colors.white : Colors.black45,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.settings,
              color: widget.selectedIndex == 2 ? Colors.white : Colors.black45,
            ),
          ),
        ],
        onTap: widget.onTap,
      ),
    );

    // Actions widget
    Widget actionsWidget;
    if (widget.actions != null && widget.actions.isNotEmpty)
      actionsWidget = IconTheme.merge(
        data: actionsIconTheme,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.actions,
        ),
      );

    final Brightness brightness =
        appBarTheme.brightness ?? theme.primaryColorBrightness;
    final SystemUiOverlayStyle overlayStyle = (brightness == Brightness.dark)
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Material(
        color: appBarTheme.color ?? theme.primaryColor,
        elevation: appBarTheme.elevation ?? 4.0,
        child: Padding(
          padding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: MediaQuery.of(context).padding.top,
          ),
          child: NavigationToolbar(
            leading: titleWidget,
            middle: middleNavigation,
            trailing: actionsWidget,
            centerMiddle: true,
          ),
        ),
      ),
    );
  }
}
