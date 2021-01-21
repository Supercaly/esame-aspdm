import 'package:aspdm_project/domain/entities/label.dart';
import 'package:aspdm_project/domain/entities/user.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/presentation/widgets/label_picker_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../locator.dart';

Future<List<User>> showUserPickerSheet(
    BuildContext context, List<User> members) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => UserPickerSheet(members: members),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    isScrollControlled: true,
  );
}

class UserPickerSheet extends StatefulWidget {
  final List<User> members;

  UserPickerSheet({Key key, this.members}) : super(key: key);

  @override
  _UserPickerSheetState createState() => _UserPickerSheetState();
}

class _UserPickerSheetState extends State<UserPickerSheet> {
  Set<User> _selected;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Members",
                  style: Theme.of(context).textTheme.headline6,
                ),
                FlatButton(
                  onPressed: () {
                    locator<NavigationService>().pop(
                      result: _selected.toList(growable: false),
                    );
                  },
                  child: Text("Done"),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Flexible(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  color: Colors.yellow,
                  child: ColumnX.builder(
                    builder: (idx) => LabelPickerItemWidget(
                      label: Label(UniqueId.empty(), Colors.red, "aa"),
                    ),
                    itemSize: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(24.0),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               "Select Members",
  //               style: Theme.of(context).textTheme.headline6,
  //             ),
  //             FlatButton(
  //               onPressed: () {
  //                 locator<NavigationService>().pop(
  //                   result: _selected.toList(growable: false),
  //                 );
  //               },
  //               child: Text("Done"),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 16.0),
  //
  //         SingleChildScrollView(
  //           controller: ModalScrollController.of(context),
  //           child: Column(
  //             //shrinkWrap: true,
  //             children: [
  //               LabelPickerItemWidget(
  //                   label: Label(UniqueId.empty(), Colors.red, "aa")),LabelPickerItemWidget(
  //                   label: Label(UniqueId.empty(), Colors.red, "aa")),LabelPickerItemWidget(
  //                   label: Label(UniqueId.empty(), Colors.red, "aa")),
  //             ],
  //           ),
  //         ),
  //
  //         // SingleChildScrollView(
  //         //   child: Column(
  //         //     mainAxisSize: MainAxisSize.min,
  //         //     children: [
  //         //       LabelPickerItemWidget(
  //         //         label: Label(UniqueId.empty(), Colors.red, "aa"),
  //         //       ),
  //         //       LabelPickerItemWidget(
  //         //         label: Label(UniqueId.empty(), Colors.red, "aa"),
  //         //       ),
  //         //       LabelPickerItemWidget(
  //         //         label: Label(UniqueId.empty(), Colors.red, "aa"),
  //         //       ),
  //         //       LabelPickerItemWidget(
  //         //         label: Label(UniqueId.empty(), Colors.red, "aa"),
  //         //       ),
  //         //       LabelPickerItemWidget(
  //         //         label: Label(UniqueId.empty(), Colors.red, "aa"),
  //         //       ),
  //         //       LabelPickerItemWidget(
  //         //         label: Label(UniqueId.empty(), Colors.red, "aa"),
  //         //       ),
  //         //       LabelPickerItemWidget(
  //         //         label: Label(UniqueId.empty(), Colors.red, "aa"),
  //         //       ),
  //         //       LabelPickerItemWidget(
  //         //         label: Label(UniqueId.empty(), Colors.red, "aa"),
  //         //       ),
  //         //
  //         //     ],
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }/
}

extension ColumnX on Column {
  static Column builder({
    Widget builder(int idx),
    int itemSize,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(itemSize, builder),
      );
}
