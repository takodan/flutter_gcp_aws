// 引用 Flutter 的核心套件
import 'package:flutter/material.dart';
import '../components/common_drawer.dart';

/// 第二頁面 - 簡單回傳文字
class SecondScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      drawer: CommonDrawer.getDrawer(context),
      body: TextButton(
        child: const Text("彈回主頁"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}