import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: 'ITI\n',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                TextSpan(
                  text: "I",
                  style: TextStyle(color: Colors.blueAccent),
                ),
                TextSpan(
                  text: "t's ",
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: 'T',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                TextSpan(
                  text: 'ime to ',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: 'I',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                TextSpan(
                  text: 'mmerse',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(color: Colors.blue),
        ],
      ),
    );
  }
}