1. 若是以顧客身份請使用order.html，若是以商家身份請使用incomplete.html
2. 檔案介紹：
    * 顧客：
        - order.html : 點餐頁面
        - comment.html : 瀏覽評論頁面
        - pay.html : 付款頁面(需搭配order.html)
        - wait.html : 等待餐點、評論頁面(需搭配pay.html)
        - logo.png : 商家的 logo
    * 商家：
        - incomplete.html : 顯示未完成的訂單資訊與商家可結單的頁面
        - ordersDetail.html : 顯示歷史訂單的資訊
        - productsDetail.html: 顯示所有商品資訊與新增商品資訊的頁面
    * 後端伺服器：
        - backendApi.js : 作為API並執行最新版本的 web3.js，補足課程中舊版 web3.js 的不足
        - 其他檔案：node_modules、package.json、package-lock.json
3. 若要啟用此專案，請使用 node.js 執行 backendApi.js
   1. npm install
   2. node backendApi.js
4. Demo影片： https://youtu.be/FnAw5ecDyAk
