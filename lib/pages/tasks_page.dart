import 'package:aspdm_project/bloc/home_bloc.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/widgets/responsive.dart';
import 'package:aspdm_project/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (_, current) => current.hasError,
      listener: (context, state) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Unknown error occurred!"))),
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
                      child: Text("Nothing to show here!"),
                    ),
                  ),
                );
              return Center(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
