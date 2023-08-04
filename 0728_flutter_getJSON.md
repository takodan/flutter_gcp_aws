匯出註解 dartdoc
# 問
!是做甚麼用的
文字控制器

# 作業
抓user資料
資料一開始顯示人名和user資料
點按鈕切換成詳細資料
樂觀鎖悲觀鎖
setState
文字控制器
# 05section2 取得資料並重新渲染畫面
- main
    1. 有一個screen/future_builder_demo_screen
        1. 用Futur非同步處理取得網路上的內容
             ```dart
            Future<dynamic> getDataFromRemote() async {
                // 解析遠端系統網址
                var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
                // 透過 http 的 get 方法，訪問該網址
                var response = await http.get(url);
                // 回結果的封包內容
                return response.body;
            }
            ```
        2. 用Widget FutureBuilder，使得資料取回之後，頁面會再重新渲染一次
            ```dart
                Widget build(BuildContext context) {
                /// [future] 接一個回傳值，為 Future 的函數
                /// [initialData] 接預設資料，在此我們設一個空陣列
                /// [builder] 必須接一個匿名函數，有兩個可調用的參數
                ///     第一個參數為記錄所有狀態的 context
                ///     第二個參數為 Future 傳回來的數據
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
            ```
# section3 把資料轉換成string以方便操作
- main
    1. 有兩個screen
        1. FutureBuilderDemoScreen()
            - 同section2
        2. PostScreen()
            - 用components/post_text()構成畫面，post_text()用FutureBuilder渲染  
                FutureBuilder裡會先加載一次builder，如果future完成會再重載一次builder
                ```dart
                return FutureBuilder(
                    // 請 PostDao使用調度外部系統資料的 Future 函數
                    // 用 1. 用daos/PostDao.getPost()取得資料並轉成成Post物件的List
                    future: PostDao.getPost(),
                    builder: (BuildContext context, AsyncSnapshot<List<Post>> asyncSnapshot) {
                    // 一個空陣列用來接轉換成string的Text
                    List<Widget> widgets = [];
                    // 確認與遠端系統交互的連線狀態
                    print(asyncSnapshot.connectionState);
                    // 確認是否已取得資料
                    print(asyncSnapshot.hasData);
                    // 如果連線狀態為已完成，則取用asyncSnapshot(這時為Post物件的List)
                    // 2. 用models/Post.toJsonObjectString()把Post物件轉成JSON規格的String
                    // 將並轉換成Text存入widgets
                    if (asyncSnapshot.connectionState == ConnectionState.done) {
                        widgets = asyncSnapshot.requireData.map((post) {
                        return Text(post.toJsonObjectString());
                        }).toList();
                    }
                    // SingleChildScrollView，使可用滑鼠滾動，瀏覽超過頁面的資料
                    // 第一次加載最後回傳SingleChildScrollView，但這時widgets是空字串，顯示空白頁
                    // 等future完成後，if成立，widgets成為Text的List，以Column顯示List資料
                    return SingleChildScrollView(
                        child: Column(
                        children: widgets,
                        ),
                    );
                    }
                );
                ```
                1. 用daos/PostDao.getPost()取得資料轉成成Post物件的List
                    ```dart
                    // 撰寫一個讀取資料的方法
                    static Future<List<Post>> getPost() async {
                        // 解析外部系統的格式
                        var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
                        // 透過 http 組件，使用 get 函數，向外部系統索取內容
                        var response = await http.get(url);

                        print("respondBodyType");
                        print(jsonDecode(response.body).runtimeType);

                        List<Post> posts = (jsonDecode(response.body) as List<dynamic>)
                            .map((jsonObject) {return Post.fromJson(jsonObject);}).toList();
                        // 將一系列 Post 物件傳回
                        return posts;
                    }
                    ```
                    - 用models/post.fromJson()把回傳的物件轉成自訂的Post物件
                2. 用models/Post.toJsonObjectString()把Post物件轉成JSON規格的String
                    ```dart
                    class Post {
                        // 要保留的Json欄位
                        int userId;
                        int id;
                        String title;
                        String body;

                        // 建構子
                        Post(this.userId, this.id, this.title, this.body);

                        // 可將Post物件轉換成符合Json規格的String
                        String toJsonObjectString() {
                            return jsonEncode({
                            "userId": this.userId,
                            "id": this.id,
                            "title": this.title,
                            "body": this.body
                            });
                        }

                        // 能將符合json規格和欄位的dynamic建置成Post物件
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
# section4 表格式呈現資料
- main
    1. 有兩個screen
        1. FutureBuilderDemoScreen()
            - 同section2
        2. PostScreen()
            1. 類似於section3的post_text()，只是最後body為components/PostTable()的Scaffold
                ```dart
                if (asyncOfPosts.connectionState == ConnectionState.done) {
                    return Scaffold(
                    // 將載入的資料當作 PostTable 的建構子，回傳一個 DataTable 物件
                        body: PostTable(asyncOfPosts.data!)
                    );
                } else {
                    return Container();
                }
                ```
                - PostTable
                    ```dart
                    class PostTable extends StatelessWidget {

                        // List<Post>，之後要進行畫面渲染，必須要有資料，故設此變數，後續用於建構子，
                        // 之後他人使用時，必須給予一個 List<Post>
                        List<Post> posts;
                        PostTable(this.posts);

                        // 建構完成後posts是Post物件的List

                        @override
                        Widget build(BuildContext context) {
                            // 從posts取出第一個物件，轉換成Json字串，jsonDecode成Map
                            // 再把Map的所有keys轉成list，之後當作column header
                            // 這時columnName會是[userId, id, title, body]
                            List<String> columnName = (jsonDecode(posts[0].toJsonObjectString()) as Map<String, dynamic>).keys.toList();
                            

                            // 建立一個新的List用來存DataColumn
                            // DataColumn是內建的class用來建構DataTable
                            // dataColumns是一個DataColumn物件的List
                            List<DataColumn> dataColumns = columnName.map((key) {
                                return DataColumn(
                                    label: Text(key)
                                );
                            }).toList();

                            // 建立一個新的List用來存DataRow
                            // DataRow是內建的class用來建構DataTable
                            // dataRows是一個DataRow物件的List
                            List<DataRow> dataRows = posts.map((post) {
                                // 將Post物件，轉換成一個Map，儲存一筆資料
                                Map<String, dynamic> postJson = jsonDecode(post.toJsonObjectString()) as Map<String, dynamic>;

                                // 把columnName作為Key，取出postMap的value轉成DataCell物件
                                // dataCells是一個DataCell物件的List
                                List<DataCell> dataCells = columnName.map((key) {
                                    return DataCell(
                                    Text(postJson[key].toString())
                                    );
                                }).toList();

                                // 把每一個row所需的dataCells加入成DataRow物件回傳
                                // 最終dataRows會是DataRow構成的List
                                return DataRow(
                                    cells: dataCells
                                    );
                            }).toList();

                            // DataTable，將身為 List<DataColumn> 的 dataColumn 與身為 List<DataRow> 的 dataRow 當作建構子放入
                            return DataTable(
                                columns: dataColumns,
                                rows: dataRows
                            );
                        }
                    }
                    ```


# section5 增加搜尋列
- main
    1. 有兩個screen
        1. FutureBuilderDemoScreen()
            - 同section2
        2. PostScreen()
            1. 類似於section4的post_text()，只是最後body為components/PostTableWithSearch()
            - PostTableWithSearch
            ```dart
            class PostTableWithSearch extends StatefulWidget {

                List<Post> posts;
                PostTableWithSearch(this.posts);
                @override
                State createState() {
                    return _PostTableWithSearch();
                }
            }

            // _代表只有這個檔案可以使用PostTableWithSearch
            class _PostTableWithSearch extends State<PostTableWithSearch> {

                // 用來存放已經篩選好的 Post
                List<Post> filteredPosts = [];

                void changeFilterPosts(String userInput) {

                    // 使用 where 函數，針對資料進行篩選
                    filteredPosts = this.widget.posts.where((element) {
                        // 若用戶不輸入任何內容，則全部保留
                        if (userInput == "") {
                            return true;
                            // 若用戶有輸入內容，且在 Post 的 title 欄位內有用戶所輸入的文字，則保留
                        } else if (element.title.contains(userInput)) {
                            print(element.title);
                            return true;
                            // 若 Post 的 title 與用戶輸入內容不同，則剔除
                        } else {
                            return false;
                        }
                    }).toList();

                    // 若查詢後，filteredPosts 的長度為 0，代表查無資料，故增加一筆假資料，告知查無資料
                    if (filteredPosts.length == 0) {
                        filteredPosts.add(Post(999, 999, "查無資料", "查無資料"));
                    }
                }

                @override
                Widget build(BuildContext context) {

                    // 若已過濾的 Post 陣列為零，代表尚未過濾
                    if (filteredPosts.length == 0) {
                        changeFilterPosts("");
                    }

                    // 建立一個新的文字控制器
                    var searchTextEditingController = TextEditingController();

                    // 建立文字輸入框
                    Widget searchBar = TextField(
                    // 將剛剛建立的文字控制器放入
                    controller: searchTextEditingController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter a search term to search Title"
                    ),
                    onSubmitted: (inputStr) {
                        // 渲染畫面
                        setState(() {
                        changeFilterPosts(inputStr);
                        });
                    },
                    );

                    // 將該字串陣列轉成 DataColumn
                    List<String> columnName = (jsonDecode(filteredPosts[0].toJsonObjectString()) as Map<String, dynamic>).keys.toList();
                    List<DataColumn> dataColumns = columnName.map((key) {
                    return DataColumn(
                        label: Text(key),
                    );
                    }).toList();

                    // 用已過濾的 Post 陣列，逐筆轉化成 DataRow
                    List<DataRow> dataRows = filteredPosts.map((post) {
                    // 轉換單筆 Post，變成 Map 資料結構
                    Map<String, dynamic> postJson = jsonDecode(post.toJsonObjectString()) as Map<String, dynamic>;
                    // 依照我們要查詢用的欄位，提取 Post 的資料內容，並轉化成 DataCell
                    List<DataCell> dataCells = columnName.map((key) {
                        return DataCell(
                        Text(postJson[key].toString())
                        );
                    }).toList();

                    // 將 DataCell 整併成一條 DataRow
                    return DataRow(
                        cells: dataCells
                    );
                    }).toList();

                    // 擔心超過畫面高度，使用 SingleChildScrollView，萬一內容超過頁面時，可用滾輪畫動檢索
                    return SingleChildScrollView(
                        child: Container(
                            alignment: Alignment.topCenter,

                            // 先放入搜尋列置頂
                            // 再放入資料表
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