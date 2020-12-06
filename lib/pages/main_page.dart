import 'package:aspdm_project/bloc/home_bloc.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/pages/settings_page.dart';
import 'package:aspdm_project/pages/tasks_page.dart';
import 'package:aspdm_project/repositories/home_repository.dart';
import 'package:aspdm_project/routes.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIdx;
  List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIdx = 0;
    _pages = [
      TasksPage(),
      Container(),
      SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(HomeRepository())..fetch(),
      child: Builder(
        builder: (context) {
          locator<LogService>()
              .logBuild("Main Page - open page at index $_currentIdx");
          return Scaffold(
            appBar: AppBar(
              title: Text((_currentIdx == 0) ? "Tasks" : "Settings"),
              centerTitle: true,
              actions: [
                if (_currentIdx == 0)
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      print("Filtrooo....");
                      context.read<HomeBloc>().fetch();
                    },
                  ),
              ],
            ),
            body: IndexedStack(
              children: _pages,
              index: _currentIdx,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIdx,
              onTap: _navigateTo,
              items: [
                BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
                BottomNavigationBarItem(
                    label: "New Task", icon: Icon(Icons.add_circle_outline)),
                BottomNavigationBarItem(
                    label: "Settings", icon: Icon(Icons.settings)),
              ],
              type: BottomNavigationBarType.fixed,
            ),
          );
        },
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
