import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/platform_controller.dart';
import 'daos/todo_dao.dart';

// 主函數，程式的入口
void main() {
  runApp(MultiProvider(providers: [
    // 使用 ChangeNotifierProvider 來提供 TodoDao 實例
    ChangeNotifierProvider(
      create: (_) => TodoDao(),
    )
  ], child: const MyApp()));
}

// MyApp 類別是一個 StatelessWidget，代表應用程序本身
class MyApp extends StatelessWidget {
  // 構造函數
  const MyApp({super.key});

  // 構建 MyApp 的 UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 設置應用程序的標題
      title: 'Flutter Demo',
      // 設置應用程序的主題
      theme: ThemeData(
        // 從指定的種子顏色生成顏色方案
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // 使用 Material Design 3 的風格
        useMaterial3: true,
      ),
      // 使用 PlatformController 作為主頁面，來判斷用戶裝置
      home: const PlatformController(),
    );
  }
}
