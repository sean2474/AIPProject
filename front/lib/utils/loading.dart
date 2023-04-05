import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final String loadingText;

  LoadingPage({super.key, this.loadingText = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(loadingText),
          ],
        ),
      ),
    );
  }
}
