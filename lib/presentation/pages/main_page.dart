import 'package:aspdm_project/presentation/bloc/home_bloc.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/presentation/pages/desktop/main_page_content_desktop.dart';
import 'package:aspdm_project/presentation/pages/mobile/main_page_content_mobile.dart';
import 'package:aspdm_project/presentation/pages/settings_page.dart';
import 'package:aspdm_project/presentation/pages/tasks_page.dart';
import 'package:aspdm_project/domain/repositories/home_repository.dart';
import 'package:aspdm_project/presentation/routes.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:aspdm_project/presentation/widgets/responsive.dart';
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
          return Responsive(
            small: MainPageContentMobile(
              currentIndex: _currentIdx,
              pages: _pages,
              navigateTo: _navigateTo,
              onFilter: () {
                print("Filtrooo....");
                context.read<HomeBloc>().fetch();
              },
            ),
            large: MainPageContentDesktop(
              currentIndex: _currentIdx,
              pages: _pages,
              navigateTo: _navigateTo,
              onFilter: () {
                print("Filtrooo....");
                context.read<HomeBloc>().fetch();
              },
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
