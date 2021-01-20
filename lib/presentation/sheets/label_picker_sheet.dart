import 'package:aspdm_project/application/bloc/labels_bloc.dart';
import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/presentation/widgets/label_picker_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<List<Label>> showLabelPickerSheet(
  BuildContext context,
  List<Label> labels,
) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => LabelPickerSheet(labels: labels),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
  );
}

class LabelPickerSheet extends StatefulWidget {
  final List<Label> labels;

  LabelPickerSheet({Key key, this.labels}) : super(key: key);

  @override
  _LabelPickerSheetState createState() => _LabelPickerSheetState();
}

class _LabelPickerSheetState extends State<LabelPickerSheet>
    with TickerProviderStateMixin {
  Set<Label> _selected;

  @override
  void initState() {
    super.initState();

    if (widget.labels != null && widget.labels.isNotEmpty)
      _selected = Set<Label>.from(widget.labels);
    else
      _selected = Set<Label>.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: BlocProvider<LabelsBloc>(
        create: (context) => LabelsBloc()..fetch(),
        child: BlocBuilder<LabelsBloc, LabelsState>(
          builder: (context, state) {
            return (state.isLoading)
                ? Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      SliverPersistentHeader(
                        delegate: _SheetSliverPersistentHeaderDelegate(),
                        pinned: true,
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate.fixed(
                          state.labels
                              .map(
                                (e) => LabelPickerItemWidget(
                                  label: e,
                                  selected: _selected.contains(e),
                                  onSelected: (selected) => setState(() {
                                    if (selected)
                                      _selected.add(e);
                                    else
                                      _selected.remove(e);
                                  }),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _SheetSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: double.maxFinite,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Select Labels",
            style: Theme.of(context).textTheme.headline6,
          ),
          FlatButton(
            onPressed: () {},
            child: Text("Done"),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
