import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {

  LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Center(child: Image.asset("assets/school_logo.png", height: 200)),
            Center(
              child: SpinKitWaveSpinner(
                color: Color.fromARGB(255, 140, 33, 49),
                trackColor: Color.fromARGB(255, 255, 165, 179),
                waveColor: Color.fromARGB(255, 140, 33, 49),
                size: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
