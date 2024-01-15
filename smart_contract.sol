// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RestaurantOrder {
    address public owner;
    uint256 public orderId;
    uint256 public commentId;

    struct Order {
        address customer; // 顧客 address
        bool isPaid; // 訂單是否已付款
        bool isCompleted; // 訂單是否已完成
        uint256[] dishQuantities; // 訂單中每個商品的數量
        uint256 total_price; // 訂單的總金額
    }
    
    struct ProductDetail {
        string img_url; // 商品圖片連結
        uint256 price; // 商品價錢
        string description; // 商品描述
    }

    struct Comment {
        address customer; // 顧客 address
        string comment; // 評論
        uint256 rating; // 可以使用整數來表示評分，(1 到 5)
    }

    string[] private allProductNames; // 記錄所有的商品名稱
    mapping(uint256 => Order) public orders; // 記錄所有的訂單
    mapping(string => ProductDetail) public Product; // 記錄所有的商品資訊
    mapping(uint256 => Comment) public comments; // 記錄所有的留言評論

    event OrderPlaced(uint256 orderId, address indexed customer, uint256[] quantities); // 下單事件
    event PaymentReceived(uint256 orderId, address indexed customer, uint256 amount); // 付款事件

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
        orderId = 1;
        commentId = 1;
        // 手動新增3個預設的商品
        addProductName("Bacon, Egg and Cheese English Muffin");
        Product["Bacon, Egg and Cheese English Muffin"].img_url = "https://www.starbucks.com.tw/common/objects/images/cake/20231128135907266.jpg";
        Product["Bacon, Egg and Cheese English Muffin"].price = 100;
        Product["Bacon, Egg and Cheese English Muffin"].description = "The soft British muffins are smeared with sweet and sour special red sauce and a little chopped onion, sandwiched with bacon slices and egg white slices, and blended with the creamy cheese. It is the best choice for breakfast.";
        
        addProductName("Mentaiko Cheese Bread");
        Product["Mentaiko Cheese Bread"].img_url = "https://www.starbucks.com.tw/common/objects/images/cake/20231128140116690.jpg";
        Product["Mentaiko Cheese Bread"].price = 140;
        Product["Mentaiko Cheese Bread"].description = "Upgraded version of Mentaiko Cheese Soft Method!Add a generous amount of mentaiko sauce and spread it evenly on the bread, then cut the bread and spread it with cheese sauce to make the overall taste warmer and more delicious.";
        
        addProductName("Pesto Chicken Pastry");
        Product["Pesto Chicken Pastry"].img_url = "https://www.starbucks.com.tw/common/objects/images/cake/20231128140259222.jpg";
        Product["Pesto Chicken Pastry"].price = 200;
        Product["Pesto Chicken Pastry"].description = "The Danish bread with rich layers is baked until crispy and shiny, filled with chicken and pesto sauce and garnished with pine nuts. This is a rich and satisfying French snack.";
    }

    // 下訂單，輸入每個商品的需求數量(_quantities)
    function placeOrder(uint256[] memory _quantities) external{
        require(getProductsCount() == _quantities.length, "Invalid input length");
        Order storage orderToUpdate = orders[orderId];
        orderToUpdate.customer = msg.sender;
        orderToUpdate.isPaid = false;
        orderToUpdate.isCompleted = false;
        
        uint256 sum = 0;
        for (uint256 i = 0; i < getProductsCount(); i++) {
            orderToUpdate.dishQuantities.push(_quantities[i]);
            sum += Product[getProductAtIndex(i)].price * _quantities[i];
        }
        orderToUpdate.total_price = sum;
        emit OrderPlaced(orderId, msg.sender, _quantities);
        orderId++;
    }

    // 新增商品(商品名、商品圖片url、商品價錢、商品描述)
    function addProduct(string memory _productName, string memory _imgUrl, uint256 _price, string memory _description) external {
        ProductDetail memory newProduct = ProductDetail({
            img_url: _imgUrl,
            price: _price,
            description: _description
        });
        addProductName(_productName);
        Product[_productName] = newProduct;
    }

    // 得到目前所有商品的資訊(商品名、商品圖片url、商品價錢、商品描述)
    function getAllProducts() external view returns (string[] memory, string[] memory, uint256[] memory, string[] memory) {
        uint256 totalProducts = getProductsCount();
        string[] memory productNames = new string[](totalProducts);
        string[] memory img_url = new string[](totalProducts);
        uint256[] memory prices = new uint256[](totalProducts);
        string[] memory descriptions = new string[](totalProducts);

        for (uint256 i = 0; i < totalProducts; i++) {
            string memory productName = getProductAtIndex(i);
            productNames[i] = productName;
            img_url[i] = Product[productName].img_url;
            prices[i] = Product[productName].price;
            descriptions[i] = Product[productName].description;
        }

        return (productNames, img_url, prices, descriptions);
    }

    // 取得產品總數
    function getProductsCount() public view returns (uint256) {
        return allProductNames.length;
    }

    // 根據 index 取得產品名稱
    function getProductAtIndex(uint256 _index) public view returns (string memory) {
        require(_index < getProductsCount(), "Index out of bounds");
        return allProductNames[_index];
    }

    // 添加產品名稱到 allProductNames
    function addProductName(string memory _productName) internal {
        allProductNames.push(_productName);
    }

    // 給定order_id，取得該訂單的資訊
    function getOrderDetail(uint256 order_id) public view returns (address, bool, bool, uint256[] memory, uint256) {
        return (orders[order_id].customer, orders[order_id].isPaid, orders[order_id].isCompleted,  orders[order_id].dishQuantities, orders[order_id].total_price);
    }

    // 完成訂單(只有老闆可以用)
    function completeOrder(uint256 order_id) external onlyOwner {
        require(orders[order_id].isPaid, "The customer didn't pay!");
        orders[order_id].isCompleted = true;
    }

    // 付款
    function payOrder(uint256 _orderId) external payable {
        Order storage order = orders[_orderId];
        require(order.customer == msg.sender, "You can only pay for your own orders");
        require(order.isPaid == false, "Order has already been paid");


        require(msg.value == order.total_price, "Incorrect payment amount");

        order.isPaid = true;
        emit PaymentReceived(_orderId, msg.sender, msg.value);
    }

    // 老闆提款(合約轉錢給老闆)
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // 新增評論(評論、評分)
    function addComment(string memory comment, uint256 rating) external {
        require(rating >= 1 && rating <= 5, "Invalid rating");

        Comment memory newComment = Comment({
            customer: msg.sender,
            comment: comment,
            rating: rating
        });

        comments[commentId] = newComment;
        commentId += 1;
    }

    // 取得所有留言的資訊(顧客address、評論、評分)
    function getAllComments() external view returns (address[] memory, string[] memory, uint256[] memory) {
        address[] memory _customers = new address[](commentId-1);
        string[] memory _comments = new string[](commentId-1);
        uint256[] memory _rating = new uint256[](commentId-1);
        
        for (uint256 i = 0; i < commentId-1; i++) {
            _customers[i] = comments[i+1].customer;
            _comments[i] = comments[i+1].comment;
            _rating[i] = comments[i+1].rating;
        }

        return (_customers, _comments, _rating);
    }

     // 取得所有尚未完成的訂單編號(order_id)
    function getAllNonCompletedOrder() external view returns (uint256[] memory) {
        uint256 uncompleted_count = 0;
        for (uint256 i = 0; i < orderId-1; i++) {
            if (!orders[i+1].isCompleted) {
                uncompleted_count += 1;
            }
        }
        uint256[] memory _order_ids = new uint256[](uncompleted_count);
        uint256 j = 0;
        for (uint256 i = 0; i < orderId-1; i++) {
            if (!orders[i+1].isCompleted) {
                _order_ids[j] = i+1;
                j = j + 1;
            }
        }
        return _order_ids;
    }

    // 取得目前最新的 orderId
    function getOrderID() external view returns (uint256) {
        return orderId;
    }
}


