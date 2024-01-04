#
## 05 section 2: Future
1. main.dart
    - similar to previous main.dart
2. screens/future_builder_demo_screen.dart
    1. import
        ```dart
        import 'package:flutter/material.dart';
        // package for http requests
        import 'package:http/http.dart' as http;
        ```
    2. class FutureBuilderDemoScreen
        ```dart
        class FutureBuilderDemoScreen extends StatelessWidget {
            // you can not make sure when a server will respond
            // using Future to do async tasks
            Future<dynamic> getDataFromRemote() async {

                // parse url
                var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
                // http get
                var response = await http.get(url);
                return response.body;
            }

            @override
            Widget build(BuildContext context) {
                // using FutureBuilder
                // when future has been changed, FutureBuilder will rerender
                // future: take a Future widget
                // initialData: data before Future return
                // builder: (BuildContext context, AsyncSnapshot<dynamic> asyncSnapshot) {}
                // asyncSnapshot is what Future return
                return FutureBuilder(
                    future: getDataFromRemote(),
                    initialData: [],
                    builder: (BuildContext context, AsyncSnapshot<dynamic> asyncSnapshot) {
                    // print(asyncSnapshot.data);
                    return Scaffold(
                        body: Text(asyncSnapshot.data.toString()),
                    );
                    }
                );
            }
        }
        ```
## 05 section 3: JSON to String
1. main.dart
    - same
2. screens/future_builder_demo_screen.dart
    - same
3. screens/post_screen.dart
    1. import
        ```dart
            import 'package:flutter/material.dart';
            import '../components/post_text.dart';
        ```
    2. class PostScreen
        - for easy maintain, build Scaffold body in post_text.dart
        ```dart
        class PostScreen extends StatelessWidget {
            @override
            Widget build(BuildContext context) {
                return Scaffold(
                    // PostText() return a FutureBuilder with a SingleChildScrollView
                    body: PostText(),  
                );
            }
        }
        ```
4. components/post_text.dart
    - to http get and determine how to show on the screen
    1. import
        ```dart
        import 'package:flutter/material.dart';
        // for HTTP get
        import '../daos/post_dao.dart';
        // for convert JSON to custom Post object 
        import '../models/post.dart';
        ```
    2. class PostText
        - for easy maintain, build Future widget in daos/post_dao.dart
        ```dart
        // building the widget we are going to show on screen
        class PostText extends StatelessWidget {
            @override
            Widget build(BuildContext context) {
                // Using FutureBuilder because we want to show the data from http get
                return FutureBuilder(
                    // PostDao.getPost() is a Future widget, return a custom Post object List
                    future: PostDao.getPost(),

                    // rander page after PostDao.getPost() finish
                    builder: (BuildContext context, AsyncSnapshot<List<Post>> asyncSnapshot) {
                        // empty List for saving data
                        List<Widget> widgets = [];

                        // connection state
                        print(asyncSnapshot.connectionState);
                        // has data
                        print(asyncSnapshot.hasData);

                        // if connection done, map Post into List for SingleChildScrollView to show on screen
                        if (asyncSnapshot.connectionState == ConnectionState.done) {
                            widgets = asyncSnapshot.requireData.map((post) {
                            return Text(post.toJsonObjectString());
                            }).toList();
                        }

                        // return SingleChildScrollView to post_screen.dart to show on screen
                        return SingleChildScrollView(
                            child: Column(
                                children: widgets,
                            ),
                        );
                    }
                );
            }
        }
        ```
5. daos/post_dao.dart
    1. import
        ```dart
        import 'package:http/http.dart' as http;
        // for decode JSON
        import 'dart:convert';
        // for convert JSON to custom Post object
        import '../models/post.dart';
        ```
    2. class PostDao
        ```dart
        class PostDao {
            // using Future async to execut http get
            static Future<List<Post>> getPost() async {
                // parse url
                var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
                // http get
                var response = await http.get(url);

                // define a List to save Post objects
                // decode JSON to a List that save JSON form Map
                // then convert Map to custom Post object
                List<Post> posts = (jsonDecode(response.body) as List<dynamic>)
                    .map((jsonObject) {return Post.fromJson(jsonObject);}).toList();
                // Post objects List
                return posts;
            }
        }
        ```
6. models/post.dart
    1. import
        ```dart
        import 'dart:convert';
        ```
    2. class Post
        ```dart
        class Post {

        // properties
        int userId;
        int id;
        String title;
        String body;

        // constructor
        Post(this.userId, this.id, this.title, this.body);

            // to convert Post object to JSON
            // no use for now
            String toJsonObjectString() {
                return jsonEncode({
                "userId": this.userId,
                "id": this.id,
                "title": this.title,
                "body": this.body
                });
            }

            // constructor
            // to receive JSON form map as parameter
            factory Post.fromJson(dynamic jsonObject) {
                return Post(
                jsonObject['userId'],
                jsonObject['id'],
                jsonObject['title'],
                jsonObject['body'],
                );
            }
        }
        ```
## 05 section 4: DataTable
1. main.dart
    - same
2. screens/future_builder_demo_screen.dart
    - same
3. screens/post_screen.dart
    - similar but using StatefulWidget
    1. import
    2. class postScreen
    ```dart
    class PostScreen extends StatefulWidget {
        @override
        State createState() {
            return _PostScreenState();
        }
    }

    class _PostScreenState extends State<PostScreen> {

        @override
        Widget build(BuildContext context) {
            return FutureBuilder(
                // return a custom Post object List
                future: PostDao.getPost(),

                builder: (BuildContext context, AsyncSnapshot<List<Post>> asyncOfPosts) {
                    if (asyncOfPosts.connectionState == ConnectionState.done) {
                        return Scaffold(
                            // invoke PostTable with a Post object List  to show data
                            body: PostTable(asyncOfPosts.data!)
                        );
                    } else {
                            // empty Container
                        return Container();
                    }
                }
            );
        }
    }
    ```
    ### Note: assert types (as), casts variable to its underlying non-nullable type (!)
    Dart. [Null assertion operator](https://dart.dev/null-safety/understanding-null-safety#null-assertion-operator)  


4. daos/post_dao.dart
    - same
5. components/post_table.dart
    1. import
        ```dart
        import 'dart:convert';
        import 'package:flutter/material.dart';
        import '../models/post.dart';
        ```
    2. class PostTable
        ```dart
        class PostTable extends StatelessWidget {
            List<Post> posts;
            // constructor
            PostTable(this.posts);

            @override
            Widget build(BuildContext context) {
                // convert posts[0] to JSON string then decode to Map
                // turn Map keys to List columnName
                // columnName is used as table column headers
                List<String> columnName = (jsonDecode(posts[0].toJsonObjectString()) as Map<String, dynamic>).keys.toList();

                // define a DataColumn List
                // DataColumn is for construct DataTable
                // using columnName as DataColumn label (column headers)
                List<DataColumn> dataColumns = columnName.map((key) {
                    return DataColumn(
                        label: Text(key)
                    );
                }).toList();

                // similar to columnName
                // but we need to convert JSON Map to DataCell
                // then put DataCells List into DataRow
                // and put DataRow into dataRows List
                List<DataRow> dataRows = posts.map((post) {
                    // post -> JsonString -> Map 
                    Map<String, dynamic> postJson = jsonDecode(post.toJsonObjectString()) as Map<String, dynamic>;

                    // using columnName as keys, get values then put into DataCell
                    List<DataCell> dataCells = columnName.map((key) {
                        return DataCell(
                            Text(postJson[key].toString())
                        );
                    }).toList();

                    return DataRow(
                        cells: dataCells
                    );
                }).toList();

                // using dataColumns(a DataColumn List) and dataRows (a DataRows List) to construct DataTable
                return DataTable(
                    columns: dataColumns,
                    rows: dataRows
                );
            }
        }

        ```
6. models/post.dart
    - same

## 05 section 5: TextField
1. main.dart
    - same
2. screens/future_builder_demo_screen.dart
    - same
3. screens/post_screen.dart
    - similar but return Scaffold with body PostTableWithSearch() from components/post_table_with_search.dart
        ```dart
        return Scaffold(
            // invoke PostTable with a Post object List  to show data
            body: PostTableWithSearch(asyncOfPosts.requireData)
        );
        ```
4. daos/post_dao.dart
    - same 
5. components/post_table_with_search.dart
    1. import
        ```dart
        import 'dart:convert';
        import 'package:flutter/material.dart';
        import '../models/post.dart';
        ```
    2. class PostTableWithSearch
        ```dart
        class PostTableWithSearch extends StatefulWidget {
            List<Post> posts;
            PostTableWithSearch(this.posts);
            @override
            State createState() {
                return _PostTableWithSearchState();
            }
        }

        class _PostTableWithSearchState extends State<PostTableWithSearch> {

            // a Post List for filtered data
            List<Post> filteredPosts = [];

            void changeFilterPosts(String userInput) {

                // where method: if return true, put element into a new lazy Iterable
                filteredPosts = this.widget.posts.where((element) {
                    // if no input, every element return true 
                    if (userInput == "") {
                        return true;
                    // if Post title contains userInput, return true (put element into Iterable).
                    } else if (element.title.contains(userInput)) {
                        print(element.title);
                        return true;
                    // else return false (do not put element into Iterable).
                    } else {
                        return false;
                    }
                }).toList();

                // if nothing in filteredPosts, add a fake data says "no data found"
                if (filteredPosts.length == 0) {
                filteredPosts.add(Post(999, 999, "no data found", "no data found"));
                }
                // now we should have a List with data we want
            }


            @override
            Widget build(BuildContext context) {

                // if nothing in the filteredPosts, it means it has not filtered yet.
                if (filteredPosts.length == 0) {
                    changeFilterPosts("");
                }

                // create a TextEditingController() for for an editable text field
                var searchBarController = TextEditingController();

                // built a searchBar with TextField
                Widget searchBar = TextField(
                // put searchBarController as controller
                controller: searchBarController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter a search term to search Title"
                ),
                    // when press enter
                    onSubmitted: (inputStr) {
                        setState(() {
                            changeFilterPosts(inputStr);
                        });
                    },
                );

                // this part similar to post_table.dart
                // convert Post data into DataTable
                List<String> columnName = (jsonDecode(filteredPosts[0].toJsonObjectString()) as Map<String, dynamic>).keys.toList();
                List<DataColumn> dataColumns = columnName.map((key) {
                    return DataColumn(
                        label: Text(key),
                    );
                }).toList();

                List<DataRow> dataRows = filteredPosts.map((post) {
                    Map<String, dynamic> postJson = jsonDecode(post.toJsonObjectString()) as Map<String, dynamic>;
                    List<DataCell> dataCells = columnName.map((key) {
                        return DataCell(
                            Text(postJson[key].toString())
                        );
                    }).toList();

                    return DataRow(
                        cells: dataCells
                    );
                }).toList();

                // using SingleChildScrollView to show the data
                return SingleChildScrollView(
                    child: Container(
                        alignment: Alignment.topCenter,

                        // put searchBar on top, then DataTable
                        child: Column(
                            children: [
                                Container(
                                    width: 800,
                                    child: searchBar,
                                ),
                                Container(
                                    width: 800,
                                    child: DataTable(
                                        columns: dataColumns,
                                        rows: dataRows,
                                    ),
                                ),
                            ],
                        ),
                    ),
                );
            }
        }
        ```
    ### NOTE: where method, TextField
    Flutter. [where method](https://api.flutter.dev/flutter/dart-core/Iterable/where.html)
    Flutter. [TextField](https://api.flutter.dev/flutter/material/TextField-class.html)
    Flutter. [InputDecoration](https://api.flutter.dev/flutter/material/InputDecoration-class.html)
    Flutter. [TextEditingController](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html)
6. models/post.dart
    - same

## 05 section 6: SharedPreferences
1. main.dart
    - same
2. screens/future_builder_demo_screen.dart
    - same
3. screens/post_screen.dart
    - same
4. daos/post_dao.dart
    - using SharedPreferences to create catch
    1. import
        ```dart
        import 'package:http/http.dart' as http;
        import 'package:shared_preferences/shared_preferences.dart';
        import 'dart:convert';
        import '../models/post.dart';
        ```
    2. class PostDao
        ```dart
        class PostDao {
            static Future<List<Post>> getPost() async {

                // // Obtain shared preferences
                SharedPreferences _prefs = await SharedPreferences.getInstance();
                // set a cache key
                String cacheKey = "posts";

                // get data from _prefs with cacheKey
                List<String>? postDataStringInCache = await _prefs.getStringList(cacheKey);

                // if postDataStringInCache have data, using data in postDataStringInCache
                // first time must go to else to put data into postDataStringInCache
                if (postDataStringInCache != null) {
                    print("get data from Cache");
                    List<Post> posts = postDataStringInCache.map((postJsonString) => Post.fromJson(jsonDecode(postJsonString))).toList();

                    return posts;
                } else {
                    print("crawl data from web");
                    var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
                    var response = await http.get(url);
                    
                    // convert data to Post object then save in a List
                    List<Post> posts = (jsonDecode(response.body) as List<dynamic>)
                        .map((jsonObject) {return Post.fromJson(jsonObject);}).toList();

                    // convert Post Object to string List
                    List<String> postsStringList = posts.map((e) => e.toJsonObjectString()).toList();
                    // save string in _prefs with cacheKey
                    _prefs.setStringList(cacheKey, postsStringList);

                    return posts;
                }
            }
        }
        ```
    ### Note SharedPreferences
    pub.dev. [shared_preferences](https://pub.dev/packages/shared_preferences)
5. components/post_table_with_search.dart
    - same
6. models/post.dart
    - same
## 05 section 7: 

1. main.dart
    - same
2. screens/future_builder_demo_screen.dart
    - same
3. screens/post_screen.dart
    - same
4. daos/post_dao.dart
    - same
5. components/post_table_with_search_and_edit.dart
    - similar to components/post_table_with_search.dart
    1. import
        ```dart
        import 'dart:convert';
        import 'package:flutter/material.dart';
        import 'package:http/http.dart' as http;
        import '../models/post.dart';
        ```
    2. class PostTableWithSearchEdit
```dart
class PostTableWithSearchEdit extends StatefulWidget {
    List<Post> posts;
    PostTableWithSearchEdit(this.posts);
    @override
    State createState() {
        return _PostTableWithSearchEditState();
    }
}

class _PostTableWithSearchEditState extends State<PostTableWithSearchEdit> {
    List<Post> filteredPosts = [];

    void changeFilteredPosts(String userInput) {...} // same

    @override
    Widget build(BuildContext context) {
        ...; // same until define dataRows
        List<DataRow> dataRows = filteredPosts.map((post) {

            // convert Post object to map
            Map<String, dynamic> postJson = jsonDecode(post.toJsonObjectString()) as Map<String, dynamic>;

            List<DataCell> dataCells = columnName.map((key) {
                return DataCell(
                // invoke TextField in DataCell for direct editing
                    TextField(
                        // TextEditingController text property for showing original data
                        controller: TextEditingController(text: postJson[key].toString()),
                        // onSubmitted
                        onSubmitted: (inputStr) {
                            // change postJson value to inputStr
                            postJson[key] = inputStr;
                            print(postJson);

                            // parse url
                            var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");

                            // http post with postJson to url
                            var responseOfFuture = http.post(url, body: jsonEncode(postJson));
                            // print response
                            responseOfFuture.then((value) => print(value.body));
                        },
                    )
                );
            }).toList();
            return DataRow(
                cells: dataCells
            );
        }).toList();
        return SingleChildScrollView(...); // same
    }
}
```

6. models/post.dart
    - same