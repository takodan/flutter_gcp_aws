import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../views/web_view.dart';
import '../views/mobile_view.dart';

class PlatformController extends StatelessWidget {
  const PlatformController({super.key});
  @override
  Widget build(BuildContext context) {
    // 判斷用戶是否為網頁應用
    if (kIsWeb) {
      // 若為網頁
      return const WebView();
    } else {
      // 若非網頁
      return const MobileView();
    }
  }
}
