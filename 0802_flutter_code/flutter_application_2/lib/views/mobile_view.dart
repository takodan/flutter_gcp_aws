import 'package:flutter/material.dart';

import '../components/mobile_drawer.dart';
import '../screens/todo_statistics_screen.dart';
import '../screens/todo_list_screen.dart';

// MobileView 類別是一個 StatefulWidget，用來表示在移動設備上的視圖
class MobileView extends StatefulWidget {
  // 構造函數
  const MobileView({super.key});
  @override
  // 產生狀態類別的實例
  State<MobileView> createState() => _MobileViewState();
}

// _MobileViewState 是 MobileView 對應的狀態類別
class _MobileViewState extends State<MobileView> {
  int _selectedPage = 0; // 用於跟蹤當前選擇的頁面
  final ScrollController _scrollController = ScrollController(); // 滾動控制器

  // 這個函數在點擊底部的導航條時觸發，將所選頁面的索引設置為當前索引
  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  // 用於存放不同頁面的 Widget
  List<Widget>? _pageOptions;

  @override
  void initState() {
    super.initState();
    // 初始化頁面選項，包括 TodoListScreen 和 TodoStatisticsScreen
    _pageOptions = [
      TodoListScreen(scrollController: _scrollController),
      const TodoStatisticsScreen(),
    ];
  }

  @override
  // 構建 UI
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar 顯示在應用程式的頂部
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('TodoList軟體架構元素範例',
            style: TextStyle(color: Colors.white)),
      ),
      // 根據所選頁面的索引顯示對應的頁面
      body: _pageOptions![_selectedPage],
      // 抽屜式側邊欄
      drawer: MobileDrawer(onItemTapped: _onItemTapped),
      // 當所選頁面為第二頁時，不顯示浮動操作按鈕
      floatingActionButton: (_selectedPage == 1)
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              },
            ),
    );
  }
}
