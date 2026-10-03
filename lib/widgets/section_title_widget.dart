import 'package:flutter/material.dart';

class SectionTitleWidget extends StatelessWidget {
  final String text;
  const SectionTitleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
