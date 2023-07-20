# outline
2-1, 2-2, 2-3：資料結構，函數，判斷=>用來建立模型和方法  
2-4, 2-5, 2-6, 2-7：List, Map, Json=>得到的外部資料儲存轉換  
2-8：http=> 取得外部資料  
2-9：單future =>異步處理  
2-10, 2-11：單future, 完成後接同系統任務=>異步處理  
2-12：多furture，多系統任務=>異步處理  
2-13：OOP=>把業務場景做成資料模型、常用方法  

## 2-1 data type
```dart
void main() {
    String str = "string";
    int number= 1;
    double decimal= 1.1;

    dynamic name = "xiao-mei";
    dynamic age = 18;
    print(name.runtimeType); // String
    print(age.runtimeType); // int
    
    print("字串可以直接相連"+str+number.toString()+decimal.toString());
    print("也可以這樣${str}$number$decimal"); // 有無{}均可
}
```

## 2-2 function
```dart
// 限定回傳為String，參數為String
String returnStringWithParameter(String inputStr) {
    String result = inputStr + "是一個字串";
    // result 必須為string
    return result;
}
// void 沒有回傳
void main(){
    String getStringFromFuntionPArameter1 = returnStringWithParameter("雲育鏈");
    print(getStringFromFuntionPArameter1);
}
```
## 2-3 if, else
```dart
void main() {
    int budget = 30000;
    if (budget > 10000) {
        print("我們現在就去公證結婚");
    } else if (budget == 10000) {
        print("雖然有點勉強，但還可以");
    } else {
        print("我爸媽說，你還年輕，還可以多衝幾年事業。");
    }
}
```

### Operators
https://dart.dev/language/operators

## 2-4 List, for
List<資料型態> 變數名 = [element1, element2, element3]
```dart
void main() {
    List<String> menList = ["王小明", "李小菜", "雲育鏈"];
    List<bool> iAmBoolList = [true, false, false, true];

    menList.add("一二三");
    print(menList[3]); // 一二三
    menList.remove("一二三");
    // 王小明
    // 李小菜
    // 雲育鏈
}
```
```dart
void main() {
    for (int index = 0; index < menList.length; index++) {
        print(menList[index]);
    }

    for (String men in menList) {
        print(men + "送早餐給小美");
    }
}
```

## 2-5 Map(key value pair)
Map<key的型別， value的型別> 變數名 = {key1: value1, key2: value2}
```dart
void main() {
    Map<String, String> positionMap = {
        "generalManager": "bing-hong",
        "humanResource": "xiao-tsai",
    };
    Map<String, int> exampleMap = {"key1": 1, "key2": 2, "key3": 3};
    Map<int, int> exampleMap2 = {2: 999, 1: 123};

    positionMap["partTime"] = "xiao-black";
    positionMap.addAll({"worker": "somebody"});
    print(positionMap["partTime"]); // xiao-black
    print(positionMap["worker"]); // somebody
    
    for (String key in positionMap.keys) {
        print("postitionMap的key是 $key 時，value為 ${positionMap[key]}");
    }
    // postitionMap的key是 generalManager 時，value為 bing-hong
    // ...
}
```

## 2-6 Json object to Map
import "dart:convert"  
jsonDecode(jsonObjectString)  
jsonEncode(dartMap)  
```dart
import "dart:convert";

void main() {
    String jsonObjectString = """{"name": "小明", "age": 28}""";
    
    // 轉換成Map
    Map<String, dynamic> dartMap = jsonDecode(jsonObjectString);
    print(dartMap["name"]); // 小明
    print(dartMap["age"]); // 28
    
    // 以Map操作
    dartMap["sex"] = "male";
    // 轉換回Json string
    String newJsonObjectString = jsonEncode(dartMap);
    print(newJsonObjectString); // {"name":"小明","age":28,"sex":"male"}
    print(newJsonObjectString.runtimeType); // String
}
```

## 2-7 Json array to List
```dart
import "dart:convert";

void main() {
    String jsonArrayString = """[{"name": "雲育鏈", "age": 18}, {"name": "小菜", "age": 25}, {"name": "小美", "age": 21}]""";
    
    // 轉換成List
    List<dynamic> dartArray = jsonDecode(jsonArrayString);
    // List內為Map
    print(dartArray[0]); // {name: 雲育鏈, age: 18}

    // 加一個Map進入List
    dartArray.add({"name": "Flutter 課程", "age": 1});
    // 轉換回 json array
    String newJsonArrayString = jsonEncode(dartArray);
}
```

## 2-8 get http package
import "package:http/http.dart"
```dart
// 轉換json套件
import "dart:convert";
// http套件
import "package:http/http.dart" as http;

// async await
void main() async {
    // create a new Uri class
    Uri url = Uri.parse('https://jsonplaceholder.typicode.com/users/1');
    // get response
    var response = await http.get(url);
    // 了解回傳型態，看要轉成Map 或List
    print(response.body);
    // 轉成Map
    Map<String, dynamic> jsonObjectFromRemote = jsonDecode(response.body);
    print(jsonObjectFromRemote['phone']);
    // 轉成List
    // List<dynamic> jsonArrayFromRemote = jsonDecode(multipleResponses.body);
    
    // 回傳
    // create a new Uri class
    Uri postItemUrl = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    // 把要回傳的資料轉換為Json
    String postRequestJsonBody = jsonEncode({"userId": "99","title": '雲育鏈', "body": '半夜寫程式，累啊。'});
    // 上傳
    var postResponse = await http.post(
        postItemUrl,
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: postRequestJsonBody);

    print(postResponse.body);
}
```
