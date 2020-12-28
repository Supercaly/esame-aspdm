import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MainPageContentMobile extends StatelessWidget {
  final int currentIndex;
  final List<Widget> pages;
  final void Function(int) navigateTo;
  final VoidCallback onFilter;

  MainPageContentMobile({
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
      appBar: AppBar(
        title: Text((currentIndex == 0) ? "Tasks" : "Settings"),
        centerTitle: true,
        actions: [
          if (currentIndex == 0)
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: onFilter,
            ),
        ],
      ),
      body: IndexedStack(
        children: pages,
        index: currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: navigateTo,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(FeatherIcons.home),
          ),
          BottomNavigationBarItem(
            label: "New Task",
            icon: Icon(FeatherIcons.plusCircle),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(FeatherIcons.settings),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
