import 'package:tasky/application/bloc/archive_bloc.dart';
import 'package:tasky/locator.dart';
import 'package:tasky/domain/repositories/archive_repository.dart';
import 'package:tasky/presentation/pages/task_list/widgets/content_widget.dart';
import 'package:tasky/presentation/pages/task_list/widgets/empty_or_error_widget.dart';
import 'package:tasky/services/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:easy_localization/easy_localization.dart';

class ArchivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArchiveBloc>(
      create: (context) => ArchiveBloc(
        repository: locator<ArchiveRepository>(),
      )..fetch(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('archive_title').tr(),
            centerTitle: true,
          ),
          body: BlocConsumer<ArchiveBloc, ArchiveState>(
            listenWhen: (_, current) => current.hasError,
            listener: (context, state) =>
                ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('unknown_error_msg').tr()),
            ),
            builder: (context, state) => LoadingOverlay(
              isLoading: state.isLoading,
              color: Colors.black45,
              child: RefreshIndicator(
                onRefresh: () =>
                    context.read<ArchiveBloc>().fetch(showLoading: false),
                child: Builder(
                  builder: (context) {
                    locator<LogService>().logBuild("ArchivePage - $state");
                    if (!state.isLoading && state.data.isEmpty)
                      return EmptyOrErrorWidget();
                    return ContentWidget(tasks: state.data);
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
