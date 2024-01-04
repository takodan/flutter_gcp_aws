# flutter quick start guide

## 03 section 2: one screen
1. main.dart  
    1. import
        ```dart
        // import flutter 
        import 'package:flutter/material.dart';
        // import screens
        import './screens/home_screen.dart';
        ```
    2. class AppEntryPoint  
        - (StatelessWidget) is "immutable"
        - all things in flutter are Widget
        ```dart
        // define a class extends from StatelessWidget
        class AppEntryPoint extends StatelessWidget {
          // override build widget
          @override
          Widget build(BuildContext context) {
            return MaterialApp(
              // named parameters
              home: HomeScreen() // (HomeScreen()) is also a Widget
            );
          }
        }
        ```
    3. void main()
        ```dart
        void main() {
          runApp(AppEntryPoint());
        }
        ```
2. home_screen.dart
    1. import flutter
    2. class HomeScreen
        - build a Widget to rendering screen
        ```dart
        class HomeScreen extends StatelessWidget {
          // similar to build widget in main.dart  
          @override
          Widget build(BuildContext context) {
            // (Scaffold()) is for holding different kind of widget on screen
            return Scaffold(
                body: Text("home screen draft")  // (Text()) is also a Widget
            );
          }
        }
        ```

## 03 section 3: Container
- similar structure
1. main.dart  
    - same
2. home_screen.dart
    1. import flutter
    2. class HomeScreen
        ```dart
        class HomeScreen extends StatelessWidget {

          @override
          Widget build(BuildContext context) {
            return Scaffold(
              // Container() is similar to CSS box model, you can set width, height, padding etc.
              body: Container(
                width: 500,
                height: 500,
                color: Colors.blue,
                child: Text(
                  "home screen draft",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            );
          }
        }
        ```
## 03 section 4: Row, Column, Expanded, SingleChildScrollView, ListVew
1. main.dart  
    - same
2. home_screen.dart
    1. import flutter
    2. class HomeScreen EXAMPLE 1: Column
        - for holding Widget vertically
        ```dart
        class HomeScreen extends StatelessWidget {

          @override
          Widget build(BuildContext context) {
            return Scaffold(
              body: Column(
                // (children : List) for multiple Widget
                children: [
                  Container(
                    child: Text(
                      "block1",
                    ),
                  ),
                  Container(
                    child: Text(
                      "block2",
                    ),
                  ),
                ],
              ),
            );
          }
        }
        ```
    3. class HomeScreen EXAMPLE 2: Expanded
        - making a child expend to fill the available space along the main axis
        ```dart
        class HomeScreen extends StatelessWidget {

          @override
          Widget build(BuildContext context) {
            return Scaffold(
              body: Column(
                children: [
                  // child expend
                  Expanded(
                    Container(...),
                  ),
                  Expanded(
                    Container(...),
                  ),
                ],
              ),
            );
          }
        }
        ```
    4. class HomeScreen EXAMPLE 3: SingleChildScrollView
        - a box in which a single widget can be scrolled
        ```dart
        class HomeScreen extends StatelessWidget {

          @override
          Widget build(BuildContext context) {
            return Scaffold(
              // not expend to fill the screen, can maintain Container size
              body: SingleChildScrollView(
                child Column(
                  children: [
                    Container(...),
                    Container(...),
                  ],
                ),
              )
            );
          }
        }
        ```
## 03 section 5: Alignment, margin, padding
1. main.dart
    - same
2. home_screen.dart
    1. import flutter
    2. class HomeScreen
        ```dart
        class HomeScreen extends StatelessWidget {

          @override
          Widget build(BuildContext context) {
            return Scaffold(
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
            );
          }
        }
        ```
## 03 section 6: multiple screens using routes
1. main.dart
    1. import flutter and screens
    2. class AppEntryPoint
        ```dart
        class AppEntryPoint extends StatelessWidget {
          @override
          Widget build(BuildContext context) {

            return MaterialApp(
              // not using home, using routes
              routes: {
                // "route": (BuildContext context) => screen widget
                "/": (BuildContext context) => HomeScreen(),
                "/second": (BuildContext context) => SecondScreen()
              },
              initialRoute: "/",
            );
          }
        }
        ```
    3. void main()

## 03 section 7: TextButton and Navigator
1. main.dart
    - same
2. home_screen.dart
    1. import flutter
    2. class HomeScreen
        ```dart
        class HomeScreen extends StatelessWidget {

          @override
          Widget build(BuildContext context) {

            return Scaffold(
              // textButton
              body: TextButton(
                child: Text("goto second page"),
                onPressed: () {
                  // navigate to "/second" with (BuildContext context)
                  Navigator.pushNamed(context, "/second");
                },
              ),
            );
          }
        }
        ```
3. second_screen.dart
    1. import flutter
    2. class HomeScreen
        ```dart
        class HomeScreen extends StatelessWidget {

          @override
          Widget build(BuildContext context) {

            return Scaffold(
              // textButton
              body: TextButton(
                child: Text("back to previous page"),
                onPressed: () {
                  // navigate back to previous page
                  Navigator.pop(context);
                },
              ),
            );
          }
        }
        ```

## 03 section 8: AppBar and Drawer
- we want to have top bar and draw on both pages
- create components/common_drawer.dart for both pages to import
1. main.dart
    - same
2. home_screen.dart
    1. import
        ```dart
        import 'package:flutter/material.dart';
        import '../components/common_drawer.dart';
        ```
    2. class HomeScreen
        ```dart
        class HomeScreen extends StatelessWidget {

          @override
          Widget build(BuildContext context) {

            return Scaffold(
              appBar: AppBar(),
              // invoke Drawer Widget from common_drawer.dart
              drawer: CommonDrawer.getDrawer(context),
              body: Text("This is Homepage")
            );
          }
        }
        ```
3. second_screen.dart
    - similar to home_screen.dart
4. common_drawer.dart
    1. import flutter
    2. class CommonDrawer
        ```dart
        class CommonDrawer {
          // build a Drawer Widget
          // using static so we don't have to instantiate a object
          // we can invoke with (CommonDrawer.getDrawer(context))
          static Drawer getDrawer(BuildContext context) {
            return Drawer(
              // recommend using ListView
              child: ListView(
                children: [
                  ListTile(
                    title: const Text("Home page"),
                    onTap: () {
                      Navigator.pushNamed(context, "/");
                    },
                  ),
                  ListTile(
                    title: const Text("Second page"),
                    onTap: () {
                      Navigator.pushNamed(context, "/second");
                    },
                  )
                ],
              ),
            );
          }
        }
        ```