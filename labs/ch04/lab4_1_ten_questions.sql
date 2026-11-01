-- 实验 4-1 回答老板的十个问题（示例库 shop，数据截至 2026-06-30）
USE shop;

-- 问题 1：2026 年 6 月 30 日这一天有几单？
SELECT COUNT(*) AS 订单数
FROM orders
WHERE DATE(order_time) = '2026-06-30';

-- 问题 2：订单 2499 买了哪些商品，一共多少钱？
SELECT product_id, quantity, unit_price, quantity * unit_price AS 小计
FROM order_item
WHERE order_id = 2499;
SELECT SUM(quantity * unit_price) AS 订单金额
FROM order_item
WHERE order_id = 2499;

-- 问题 3：哪些商品缺货或库存不足 20 件？按库存从少到多排
SELECT product_id, name, stock
FROM product
WHERE stock < 20
ORDER BY stock;

-- 问题 4：最贵的 5 种商品
SELECT name, price
FROM product
ORDER BY price DESC
LIMIT 5;

-- 问题 5：名字里带“奶”的商品
SELECT name, price
FROM product
WHERE name LIKE '%奶%';

-- 问题 6：2026 年 6 月一共多少单？其中退款几单？
SELECT status, COUNT(*) AS 单数
FROM orders
WHERE order_time >= '2026-06-01' AND order_time < '2026-07-01'
GROUP BY status;

-- 问题 7：2026 年上半年，每种支付方式各多少单（只算已完成）？
SELECT pay_method, COUNT(*) AS 单数
FROM orders
WHERE order_time >= '2026-01-01' AND order_time < '2026-07-01'
  AND status = '已完成'
GROUP BY pay_method
ORDER BY 单数 DESC;

-- 问题 8：下单次数最多的 5 位顾客（不算散客）
SELECT customer_id, COUNT(*) AS 下单次数
FROM orders
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY 下单次数 DESC
LIMIT 5;

-- 问题 9：每个小区的顾客有多少人？
SELECT district, COUNT(*) AS 人数
FROM customer
GROUP BY district
ORDER BY 人数 DESC;

-- 问题 10：毛利率最高的 5 种商品
SELECT name, price, cost,
       ROUND((price - cost) / price * 100, 1) AS 毛利率
FROM product
ORDER BY 毛利率 DESC
LIMIT 5;
