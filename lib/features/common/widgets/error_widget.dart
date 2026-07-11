import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final Object error;
  const ErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error.toString()));
  }
}
