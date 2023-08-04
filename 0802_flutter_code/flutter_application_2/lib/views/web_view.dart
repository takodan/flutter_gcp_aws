import 'package:flutter/material.dart';

import '../screens/todo_list_screen.dart';
import '../screens/todo_statistics_screen.dart';

// WebView 類別是一個 StatefulWidget，用於呈現在網頁視圖上
class WebView extends StatefulWidget {
  // 構造函數
  const WebView({Key? key}) : super(key: key);

  // 生成狀態對象的實例
  @override
  State<WebView> createState() => _WebViewState();
}

// _WebViewState 是 WebView 對應的狀態類別
class _WebViewState extends State<WebView> {
  final ScrollController _scrollController = ScrollController(); // 滾動控制器
  int _selectedIndex = 0; // 用於跟蹤當前選擇的頁面的索引

  // 構建 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('TodoList軟體架構元素範例',
            style: TextStyle(color: Colors.white)),
      ),
      body: Row(
        children: [
          // 側邊欄，用於切換頁面
          SizedBox(
            width: 200,
            child: ListView(
              children: <Widget>[
                // Todo List 選項
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Todo List'),
                  selected: _selectedIndex == 0,
                  onTap: () {
                    // 點擊後將所選索引設置為 0
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                // 任務統計 選項
                ListTile(
                  leading: const Icon(Icons.analytics),
                  title: const Text('任務統計'),
                  selected: _selectedIndex == 1,
                  onTap: () {
                    // 點擊後將所選索引設置為 1
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ],
            ),
          ),
          // 如果選中的是 TodoListScreen，則展示 TodoListScreen
          if (_selectedIndex == 0)
            Expanded(
              child: TodoListScreen(scrollController: _scrollController),
            ),
          // 如果選中的是 TodoStatisticsScreen，則展示 TodoStatisticsScreen
          if (_selectedIndex == 1)
            const Expanded(
              child: TodoStatisticsScreen(),
            ),
        ],
      ),
      // 浮動操作按鈕，用於控制滾動位置
      floatingActionButton: (_selectedIndex == 0)
          ? FloatingActionButton(
              onPressed: () {
                // 按下按鈕後，將滾動位置設置為頂部
                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.arrow_upward), // 使用向上箭頭的圖標
            )
          : null,
    );
  }
}
