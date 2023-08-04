import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // here the desired height
        child: AppBar( 
          backgroundColor: Colors.white,
        // 新增中間文字
        title: Container(
          alignment: Alignment.centerRight,
          height: 80,
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                  child: Image.asset('/star.png', fit: BoxFit.contain,),
              ),
              Container(
                child: Image.asset('/star.png', fit: BoxFit.contain,),
              ),
              Container(
                width: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text('Click edit and create your own amazing website',style: TextStyle(color: Colors.black, fontSize: 12),),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text('進一步了解',style: TextStyle(color: Colors.black, fontSize: 14),),
                color: Colors.purple,
              ),
            ]
          ),
        ),
        leading: IconButton(
          padding: EdgeInsets.only(left: 10),
          icon: Image.asset('/star.png'),
          onPressed: () {},
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20, top: 10, bottom: 10, left: 20),
            child: Container(
              width: 100,
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text('ThisIsABotton',style: TextStyle(color: Colors.black ),)
            ),
          ),
        ],
      ),
      ),
      body: Text("Hello"),
    ); 
  }
}