import 'package:flutter/material.dart';
import '../components/common_drawer.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 加入 appbar 和 drawer
      appBar: AppBar(),
      drawer: CommonDrawer.getDrawer(context),
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
            child: TextButton(
              child: Text("切換到第二頁"),
              onPressed: () {
                Navigator.pushNamed(context, "/second");
              },
            ),
          ),
        ),
      ),
    );
  }
}