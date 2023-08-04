import 'package:flutter/material.dart';

import './home_screen.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('第二頁'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton(
            child: const Text('返回上一頁'),
            onPressed: () {
              // 使用 Navigator.pop 返回上一頁
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('pushReplacement 返回首頁'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                // MaterialPageRoute(builder: (context) => const HomeScreen()),
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
        ]),
      ),
    );
  }
}
