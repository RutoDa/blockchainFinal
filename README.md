# 早餐店點餐系統-112區塊鏈小專題實作
利用智能合約實作功能完整的點餐系統。提供賣家新增餐點資訊、確認訂單資訊以及提供買家下單及評論。
## Demo影片
<a href="https://youtu.be/FnAw5ecDyAk"><img src="https://github.com/RutoDa/blockchainFinal/blob/main/readme_img/cover_img.png?raw=true" width=600></a>
* [YouTube連結：https://youtu.be/FnAw5ecDyAk](https://youtu.be/FnAw5ecDyAk)

## 使用說明
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
    * 智能合約：
        - smart_contract.sol : 智能合約程式碼 
3. 若要啟用此專案，請使用 node.js 執行 backendApi.js
   ```bash
   npm install
   ```
   ```bash
   node backendApi.js
   ```
4. Demo影片： https://youtu.be/FnAw5ecDyAk
5. 成果投影片： [連結](https://github.com/RutoDa/blockchainFinal/blob/main/%E6%88%90%E6%9E%9C%E7%B0%A1%E5%A0%B1/%E5%8D%80%E5%A1%8A%E9%8F%88%E6%9C%9F%E6%9C%AB%E5%B0%88%E9%A1%8C%E6%88%90%E6%9E%9C%E7%B0%A1%E5%A0%B1.pptx)
