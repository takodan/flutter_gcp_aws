import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import './second_screen.dart';
// 引入 logger 用來記錄狀態
import '../utils/logger.dart';

// 定義一個 StatefulWidget 名為 HomeScreen
class HomeScreen extends StatefulWidget {
  // 建構子，接收 key 並將其傳遞給父類
  const HomeScreen({Key? key}) : super(key: key);

  // 創建狀態物件
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// 定義一個與 HomeScreen 對應的 State
class _HomeScreenState extends State<HomeScreen> {
  // 當此物件插入到樹中時被調用，將會在掛載到樹上之後調用
  @override
  void initState() {
    super.initState();
    logger.d('initState'); // 記錄狀態
  }

  // 在父 Widget調用 setState, 即觸發此方法。除非父 Widget 在調用這個 widget 時，設定為 const
  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    logger.d('didUpdateWidget'); // 記錄狀態
  }

  // 當此物件從樹中移除時被調用
  @override
  void dispose() {
    if (!kIsWeb) {
      writeToFile('This is the dispose message.').then((_) {});
    }

    logger.d('dispose');
    super.dispose();
  }

  // 僅 Android App可使用
  Future<void> writeToFile(String data) async {
    final dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/dispose.txt');
    await file.writeAsString(data);
  }

  // 構建畫面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StatefulWidget 生命循環'),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          '請確認終端機的 Log。',
        ),
        TextButton(
          child: const Text("觸發狀態重建"),
          onPressed: () {
            setState(() {
              logger.d("setState");
            });
          },
        ),
        TextButton(
          child: const Text("push 前往第二頁"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondScreen()),
            );
          },
        ),
        TextButton(
          child: const Text("pushReplacement 前往第二頁"),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SecondScreen()),
            );
          },
        ),
        if (!kIsWeb)
          TextButton(
            child: const Text("寫檔案"),
            onPressed: () async {
              try {
                await writeToFile('寫檔案測試.');
              } catch (e) {
                logger.e(e);
              }
            },
          ),
      ])),
    );
  }
}
