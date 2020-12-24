import 'package:aspdm_project/bloc/archive_bloc.dart';
import 'package:aspdm_project/locator.dart';
import 'package:aspdm_project/repositories/archive_repository.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ArchivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArchiveBloc>(
      create: (context) => ArchiveBloc(ArchiveRepository())..fetch(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Archived Tasks"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  // TODO: Put filter logic here.
                  print("Filtering...");
                  context.read<ArchiveBloc>().fetch();
                },
              ),
            ],
          ),
          body: BlocConsumer<ArchiveBloc, ArchiveState>(
            listenWhen: (_, current) => current.hasError,
            listener: (context, state) =>
                ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Unknown error occurred!")),
            ),
            builder: (context, state) => LoadingOverlay(
              isLoading: state.isLoading,
              color: Colors.black45,
              child: RefreshIndicator(
                onRefresh: () =>
                    context.read<ArchiveBloc>().fetch(showLoading: false),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    locator<LogService>().logBuild("ArchivePage - $state");
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
                    return ListView.builder(
                      itemBuilder: (_, index) =>
                          TaskCard(task: state.data[index]),
                      itemCount: state.data.length,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
