-- 实验 8-1 为小店建三个视图，按角色查询（视图建在示例库 shop 里，不改动数据）
USE shop;

-- 视图 1：订单明细“大表”——给老板和会计看，省得每次都写四表连接
CREATE OR REPLACE VIEW v_order_detail AS
SELECT o.order_id, o.order_time, o.status, o.pay_method,
       IFNULL(c.name, '散客') AS customer_name,
       p.name AS product_name, cat.name AS category_name,
       oi.quantity, oi.unit_price, oi.quantity * oi.unit_price AS subtotal
FROM orders o
LEFT JOIN customer c ON c.customer_id = o.customer_id
JOIN order_item oi   ON oi.order_id = o.order_id
JOIN product p       ON p.product_id = oi.product_id
JOIN category cat    ON cat.category_id = p.category_id;

-- 视图 2：给收银员看的商品表——只有名称、售价、库存，看不到进价和供应商
CREATE OR REPLACE VIEW v_cashier_product AS
SELECT product_id, name, price, stock, unit
FROM product;

-- 视图 3：每月销售额（只算已完成订单）
CREATE OR REPLACE VIEW v_monthly_sales AS
SELECT DATE_FORMAT(order_time, '%Y-%m') AS month,
       COUNT(DISTINCT order_id) AS orders,
       SUM(subtotal) AS sales
FROM v_order_detail
WHERE status = '已完成'
GROUP BY month;

-- 用视图查询：和查表一模一样
SELECT order_id, customer_name, product_name, quantity, subtotal
FROM v_order_detail WHERE order_id = 2499;

SELECT * FROM v_cashier_product WHERE stock < 10;

SELECT * FROM v_monthly_sales WHERE month >= '2026-01' ORDER BY month;

-- 看看数据库里有哪些视图
SHOW FULL TABLES WHERE Table_type = 'VIEW';
