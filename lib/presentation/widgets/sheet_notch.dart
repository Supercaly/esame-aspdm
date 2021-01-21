import 'package:flutter/material.dart';

/// Widget that display a notch at the top of
/// a modal bottom sheet.
class SheetNotch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.0,
      height: 6.0,
      decoration: BoxDecoration(
        color: Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(24.0)
      ),
    );
  }
}
