import 'package:tasky/application/bloc/home_bloc.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/services/log_service.dart';
import 'package:tasky/presentation/widgets/responsive.dart';
import 'package:tasky/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:easy_localization/easy_localization.dart';
import '../theme.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (_, current) => current.hasError,
      listener: (context, state) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('unknown_error_msg').tr())),
      builder: (context, state) => LoadingOverlay(
        isLoading: state.isLoading,
        color: Colors.black45,
        child: RefreshIndicator(
          onRefresh: () => context.read<HomeBloc>().fetch(showLoading: false),
          child: LayoutBuilder(
            builder: (context, constraints) {
              locator<LogService>().logBuild("TaskPage - $state");
              if (!state.isLoading && state.data.isEmpty)
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Text('nothing_to_show_msg').tr(),
                    ),
                  ),
                );
              return Center(
                child: Theme(
                  data: Responsive.isLarge(context)
                      ? Theme.of(context).brightness == Brightness.light
                          ? lightThemeDesktop
                          : darkThemeDesktop
                      : Theme.of(context),
                  child: Container(
                    width: Responsive.isLarge(context) ? 500 : double.maxFinite,
                    padding: Responsive.isLarge(context)
                        ? const EdgeInsets.only(top: 24.0)
                        : null,
                    child: ListView.builder(
                      itemBuilder: (_, index) =>
                          TaskCard(task: state.data[index]),
                      itemCount: state.data.length,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
