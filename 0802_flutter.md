1. main
2. controllers: 分辨使用裝置為網頁還是手機，進行導流
3. views: 看到的整個畫面
4. screens: 將畫面切割成多個以方便分工或排版
5. components: 不同畫面可能會用到相同組件
6. services: 資料處理
6. daos: 連接到外部存取資料
7. models: 

1. main
2. Multiprovider

3. MyApp
    1. title
    2. theme
    3. home: PlatformController()
        判斷手機還是桌機
        1. WebView()
            1. statefull widget 
            2. ScrollController() 後面用來控制畫面
            3. _selectedIndex 後面用欄控制要哪個頁面
            3. Appbar 上方欄
            4. Row 頁面左右呈現
                1. SizedBox 側邊欄
                    1. ListTile() 側邊欄選項
                        _selectedIndex 判斷是否被選擇，更改參數以變後面顯示頁面
                2. if(_selectedIndex) 由前面設定的參數顯示不同畫面
                    1. TodoListScreen()
                    2. TodoStatisticsScreen()
            5. floatingActionButton() 回到頂端懸浮按鈕
                1. 以ScrollController()控制畫面位置
        2. MobileView() 