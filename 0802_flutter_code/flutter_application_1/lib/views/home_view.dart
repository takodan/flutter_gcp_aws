import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool toggle = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (toggle) const Expanded(child: HomeScreen()),
        if (!toggle) const Expanded(child: HomeScreen()),
        // const Expanded(child: HomeScreen()),
        // Expanded(child: HomeScreen()),
        Expanded(
          child: TextButton(
            child: Text("觸發狀態重建: toggle: $toggle"),
            // child: const Text("觸發狀態重建"),
            onPressed: () {
              setState(() {
                toggle = !toggle;
              });
            },
          ),
        ),
      ],
    );
  }
}
