import 'dart:convert';

import 'package:uuid/uuid.dart';

class Todo {
  // 屬性
  String id; // 新增的 id 屬性
  String title;
  String description;
  bool completed;

  /// 建構子
  Todo(this.id, this.title, this.description, this.completed);

  // 我們覆蓋了 `==` 運算符以實現兩個 Todo 對象的內容比較
  // 而不是基於它們在內存中的位置
  @override
  bool operator ==(Object other) {
    // 如果 `this` 和 `other` 是同一個對象（即他們在內存中的位置相同）
    // 那麼我們可以直接返回 true，因為它們確實是相等的
    if (identical(this, other)) return true;

    // 如果 `other` 是一個 Todo 對象，且其 `id`, `title`, `description`
    // 和 `completed` 屬性的值都與 `this` 對象相同，那麼我們認為 `this` 和 `other` 是相等的
    // 如果它們的任一屬性不同，那麼 `this` 和 `other` 就不相等
    return other is Todo &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.completed == completed;
  }

  // 我們同樣覆蓋了 hashCode 方法，以確保有相同屬性值的 Todo 對象有相同的 hashCode
  // 這是一個良好的 Dart 編程實踐，特別是當你覆蓋 `==` 運算符時
  // 注意我們是如何通過將每個屬性的 hashCode 進行互斥或操作（^）來計算 hashCode 的
  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        completed.hashCode;
  }

  /// 序列化，將物件直接轉換為 json string
  String toJsonString() {
    Map<String, dynamic> _jsonMap = {
      "id": id, // 新增 id 至 json map 中
      "title": title,
      "description": description,
      "completed": completed,
    };
    return jsonEncode(_jsonMap);
  }

  /// 讀取 json map 並轉換成物件的建構子
  factory Todo.fromJson(Map<String, dynamic> _json) {
    var uuid = const Uuid();
    // 提取內容值
    String id = _json["id"] ?? uuid.v4(); // 新增讀取 id 的程式碼
    String title = _json["title"];
    String description = _json["description"];
    bool completed = _json["completed"];

    // 回傳物件
    return Todo(id, title, description, completed); // 將 id 新增至建構子參數中
  }
}
