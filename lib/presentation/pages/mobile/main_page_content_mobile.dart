// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:easy_localization/easy_localization.dart';

class MainPageContentMobile extends StatelessWidget {
  final int currentIndex;
  final List<Widget> pages;
  final void Function(int) navigateTo;

  MainPageContentMobile({
    Key key,
    this.currentIndex,
    this.pages,
    this.navigateTo,
  })  : assert(currentIndex != null && currentIndex >= 0),
        assert(pages != null && pages.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text((currentIndex == 0) ? 'tasks_title' : 'settings_title').tr(),
        centerTitle: true,
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
            label: 'home_page'.tr(),
            icon: Icon(FeatherIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'new_task_page'.tr(),
            icon: Icon(FeatherIcons.plusCircle),
          ),
          BottomNavigationBarItem(
            label: 'settings_page'.tr(),
            icon: Icon(FeatherIcons.settings),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
