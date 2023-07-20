# outline
These quick guides base on this lib folder structure.
1. screens 顯示頁面 (view): TODAY
2. dao 資料庫溝通
3. controller 辨識使用裝置
4. component 放置常用widget (widgets): some
5. service 資料邏輯操作

## start a new project
VSCode -> Flutter: New Project -> Application
## Flutter VSCode autofill extension
Awesome Flutter Snippets
# main
Flutter裡萬物都是Widget, 也只有Widget可以被渲染在畫面上
```dart
// 基處套件
import 'package:flutter/material.dart';
// 其他套件/頁面
import './screens/home_screen.dart';
// main相當於APP入口, 啟動AppEntryPoint
void main() {
    runApp(const AppEntryPoint());
}

// 繼承StatelessWidget使AppEntryPoint是Widget
class AppEntryPoint extends StatelessWidget {
    const AppEntryPoint({super.key})

    // MaterialApp相當於核心必備的畫框
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            // home參數從home_screen.dart接入Widget
            home: HomeScreen()
        );
    }
}
```
# screens
```dart
import 'package:flutter/material.dart';

// 我們若要做視覺化內容, 只需建立class繼承StatelessWidget
// 在StatelessWidget內有一個未實踐的build
// 我們只需要在裡面重新實踐build, 並在最後傳回一個Widget即可
class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Scaffold是預設的Widget, 就像一張大畫布, 裡面可以承載其他Widget
    return const Scaffold(
        body: Text("個人首頁的粗搞")
    );
  }
}
```
# Flutter Layouts
https://docs.flutter.dev/ui/layout  

## container (similar to CSS box model)
```dart
// 第一層Container
body: Container(
    // 內容物置中
    alignment: Alignment.topCenter,
    // 大小 500 x 500
    width: 500, height: 500,
    // 外距50 
    margin: EdgeInsets.all(50),
    // 填滿blue
    color: Colors.blue,
    child: Container(
        width: 300,
        height: 600,
        // 外距上100, 使得height最多是400
        margin: EdgeInsets.only(top: 100),
        // 內距50, 使第三層最多是250*350
        padding: EdgeInsets.all(50),
        color: Colors.red,
        // 第三層 Container
        child: Container(
            // 上一層沒有alignment無法固定width, height
            // 會填滿250*350
            width: 10,
            height: 10,
            color: Colors.orange,
        ),
    ),
),
```
## row, column
## Expend, SingleChildScrollView, ListVew

## routes
in main.dart
```dart
return MaterialApp(
    routes: {
        // "路徑": (BuildContext context) => 頁面物件
        "/": (BuildContext context) => HomeScreen(),
        "/second": (BuildContext context) => SecondScreen()
    },
    // 起始頁面路徑
    initialRoute: "/",
);
```

## text button
```dart
return Scaffold(
    body: TextButton(
    child: Text("切換到第二頁"),
        onPressed: () {
            Navigator.pushNamed(context, "/second");
            // Navigator.pushReplacementNamed(context, "/second"); // 轉跳後無法返回上一頁
            // Navigator.pop(context); // 回上一頁
        },
    ),
)
```

## drawer
另建立一個dart在components
```dart
import 'package:flutter/material.dart';

class CommonDrawer {
  static Drawer getDrawer(BuildContext context) {
    return Drawer(
      /// child參數接ListView
      child: ListView(
        children: [
          ListTile(
            title: const Text("主頁"),
            onTap: () {
              // 轉發至首頁
              Navigator.pushNamed(context, "/");
            },
          ),
          ListTile(
            title: const Text("第二個分頁"),
            onTap: () {
              // 轉發至第二分頁
              Navigator.pushNamed(context, "/second");
            },
          )
        ],
      ),
    );
  }
}
```

## Image
in pubspec.yaml
```yaml
flutter:
  assets:
    - images/
```
in screen
```dart
Image(image: AssetImage('image path'));
// or
Image.asset('image path');
```

## 封裝成html
```bash
flutter clean
flutter build web
```

## 上github
```bash

```
