import 'package:flutter/material.dart';

class LoadingWedget extends StatelessWidget {
  const LoadingWedget({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.transparent,
      // valueColor: AlwaysStoppedAnimation<Color>(),
      minHeight: 2,
    );
  }
}
