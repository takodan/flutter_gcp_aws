import 'package:flutter/material.dart';

// 這是一個手機版的側滑抽屜（Drawer）元件，提供選單的選項讓用戶進行頁面導航。
class MobileDrawer extends StatelessWidget {
  // 這是一個回調函數，當用戶點擊抽屜中的一個選項時，會調用這個函數並傳入選項的索引。
  final ValueChanged<int> onItemTapped;

  // 構造函數，初始化時需要傳入一個回調函數。
  const MobileDrawer({required this.onItemTapped, super.key});

  @override
  Widget build(BuildContext context) {
    // 抽屜主要包含一個ListView元件，ListView中包含兩個選項。
    return Drawer(
      child: ListView(
        // 將邊距設為零
        padding: EdgeInsets.zero,
        children: <Widget>[
          // 抽屜頭部，包含一個標題"選單"。
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[900],
            ),
            child: const Text('選單', style: TextStyle(color: Colors.white)),
          ),
          // 抽屜中的第一個選項，標題為"TodoList清單"。
          ListTile(
            title: const Text('TodoList清單'),
            onTap: () {
              // 點擊時調用回調函數，並傳入選項索引為0。
              onItemTapped(0);
              // 點擊後關閉抽屜。
              Navigator.pop(context);
            },
          ),
          // 抽屜中的第二個選項，標題為"任務統計頁面"。
          ListTile(
            title: const Text('任務統計頁面'),
            onTap: () {
              // 點擊時調用回調函數，並傳入選項索引為1。
              onItemTapped(1);
              // 點擊後關閉抽屜。
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
