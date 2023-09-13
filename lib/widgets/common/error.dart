import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomErrorWidget({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'An error occurred: ${errorDetails.exceptionAsString()}',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }
}
