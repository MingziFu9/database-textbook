-- 实验 7-2 把“订单大宽表”拆到第三范式，验证三种异常消失
DROP DATABASE IF EXISTS normdemo;
CREATE DATABASE normdemo DEFAULT CHARACTER SET utf8mb4;
USE normdemo;

-- 第 1 步：用示例库 shop 的数据，造一张“什么都往里放”的大宽表（2025 年 1 月的订单）
CREATE TABLE order_wide AS
SELECT o.order_id, o.order_time, o.customer_id, c.name AS customer_name, c.phone AS customer_phone,
       oi.product_id, p.name AS product_name, cat.name AS category_name, oi.unit_price, oi.quantity
FROM shop.orders o
JOIN shop.customer c    ON c.customer_id = o.customer_id
JOIN shop.order_item oi ON oi.order_id = o.order_id
JOIN shop.product p     ON p.product_id = oi.product_id
JOIN shop.category cat  ON cat.category_id = p.category_id
WHERE o.order_time < '2025-02-01';
ALTER TABLE order_wide ADD PRIMARY KEY (order_id, product_id);

SELECT COUNT(*) AS 大宽表行数 FROM order_wide;
SELECT * FROM order_wide ORDER BY order_id, product_id LIMIT 4;

-- 第 2 步：看看冗余有多严重：同一个顾客的电话重复存了几次？同一个商品名呢？
SELECT customer_id, customer_name, COUNT(*) AS 电话重复次数
FROM order_wide GROUP BY customer_id, customer_name ORDER BY 电话重复次数 DESC LIMIT 3;

-- 第 3 步：更新异常：顾客换了手机号，要改多少行？只改一行会怎样？
UPDATE order_wide SET customer_phone = '10099999999'
WHERE customer_id = 28 AND order_id = (SELECT MIN(order_id) FROM (SELECT order_id FROM order_wide WHERE customer_id = 28) t);
SELECT DISTINCT customer_phone FROM order_wide WHERE customer_id = 28;

-- 第 4 步：删除异常：只有一张订单买过的商品，删掉这张订单，商品信息也没了
SELECT product_id, product_name, COUNT(*) AS 出现次数
FROM order_wide GROUP BY product_id, product_name HAVING COUNT(*) = 1 ORDER BY product_id;

-- 第 5 步：插入异常：新商品还没人买，没有订单号，能放进大宽表吗？（这一句会报错，是预期的）
INSERT INTO order_wide (order_id, product_id, product_name, category_name) VALUES (NULL, 99, '新品酸梅汤', '饮料');

-- 第 6 步：拆成第三范式的 4 张表（数据从大宽表里取，先把第 3 步改乱的电话改回来）
UPDATE order_wide w JOIN shop.customer c ON c.customer_id = w.customer_id SET w.customer_phone = c.phone;
CREATE TABLE customer3 AS SELECT DISTINCT customer_id, customer_name, customer_phone FROM order_wide;
CREATE TABLE product3  AS SELECT DISTINCT product_id, product_name, category_name FROM order_wide;
CREATE TABLE orders3   AS SELECT DISTINCT order_id, order_time, customer_id FROM order_wide;
CREATE TABLE item3     AS SELECT order_id, product_id, unit_price, quantity FROM order_wide;
ALTER TABLE customer3 ADD PRIMARY KEY (customer_id);
ALTER TABLE product3  ADD PRIMARY KEY (product_id);
ALTER TABLE orders3   ADD PRIMARY KEY (order_id);
ALTER TABLE item3     ADD PRIMARY KEY (order_id, product_id);

SELECT 'customer3' AS 表, COUNT(*) AS 行数 FROM customer3
UNION ALL SELECT 'product3', COUNT(*) FROM product3
UNION ALL SELECT 'orders3', COUNT(*) FROM orders3
UNION ALL SELECT 'item3', COUNT(*) FROM item3;

-- 第 7 步：验证“拆了能拼回去”：四表连接后的行数应和大宽表一样，且没有对不上的行
SELECT COUNT(*) AS 拼回去的行数
FROM item3 i
JOIN orders3 o    ON o.order_id = i.order_id
JOIN customer3 c  ON c.customer_id = o.customer_id
JOIN product3 p   ON p.product_id = i.product_id;

SELECT COUNT(*) AS 不一致的行数
FROM order_wide w
LEFT JOIN (item3 i JOIN orders3 o ON o.order_id = i.order_id
                   JOIN customer3 c ON c.customer_id = o.customer_id
                   JOIN product3 p ON p.product_id = i.product_id)
       ON i.order_id = w.order_id AND i.product_id = w.product_id
          AND c.customer_phone <=> w.customer_phone AND p.product_name = w.product_name
WHERE i.order_id IS NULL;

-- 第 8 步：拆分以后，换手机号只改一行
UPDATE customer3 SET customer_phone = '10099999999' WHERE customer_id = 28;
