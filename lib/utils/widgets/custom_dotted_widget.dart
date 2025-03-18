import 'package:dotted_line_flutter/dotted_line_flutter.dart';
import 'package:flutter/material.dart';

class CustomDottedWidget extends StatelessWidget {
  const CustomDottedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: CustomPaint(
          painter: DottedLinePainter(
            lineThickness: 1.0,
            dashGap: 5.0,
            gapColor: Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
