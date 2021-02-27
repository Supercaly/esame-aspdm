import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class EmptyOrErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Center(
            child: Text('nothing_to_show_msg').tr(),
          ),
        ),
      ),
    );
  }
}
