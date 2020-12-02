import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/pages/settings_page.dart';
import 'package:aspdm_project/pages/tasks_page.dart';
import 'package:aspdm_project/routes.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIdx;

  @override
  void initState() {
    super.initState();
    _currentIdx = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tasks")),
      body: IndexedStack(
        children: [
          TasksPage(),
          Container(),
          SettingsPage(),
        ],
        index: _currentIdx,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIdx,
        onTap: _navigateTo,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "New Task", icon: Icon(Icons.add_circle_outline)),
          BottomNavigationBarItem(label: "Settings", icon: Icon(Icons.settings)),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _navigateTo(int newIdx) {
    // Navigate to NewTaskPage
    if (newIdx == 1) {
      locator<NavigationService>().navigateTo(Routes.newTask);
    } else
      setState(() => _currentIdx = newIdx);
  }
}
