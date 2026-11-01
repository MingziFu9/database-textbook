-- 实验 5-3 找出“买了 A 也买了 B”的商品组合（示例库 shop）
USE shop;

-- 第 1 步：同一张订单里的两件商品配成一对（order_item 和自己连接）
--   a.product_id < b.product_id：每对只算一次，也不和自己配对
SELECT a.order_id, a.product_id AS 商品A, b.product_id AS 商品B
FROM order_item a
JOIN order_item b ON b.order_id = a.order_id AND a.product_id < b.product_id
WHERE a.order_id = 2499;

-- 第 2 步：统计每一对一起出现在多少张订单里，取前 10，并换成商品名
WITH pairs AS (
  SELECT a.product_id AS pa, b.product_id AS pb, COUNT(*) AS 同单次数
  FROM order_item a
  JOIN order_item b ON b.order_id = a.order_id AND a.product_id < b.product_id
  GROUP BY a.product_id, b.product_id
)
SELECT p1.name AS 商品A, p2.name AS 商品B, pairs.同单次数
FROM pairs
JOIN product p1 ON p1.product_id = pairs.pa
JOIN product p2 ON p2.product_id = pairs.pb
ORDER BY pairs.同单次数 DESC, pairs.pa, pairs.pb
LIMIT 10;

-- 第 3 步：买了“燕麦片 1kg”（商品 8）的订单里，还常买什么？
SELECT p.name AS 一起买的商品, COUNT(*) AS 次数
FROM order_item a
JOIN order_item b ON b.order_id = a.order_id AND b.product_id <> a.product_id
JOIN product p    ON p.product_id = b.product_id
WHERE a.product_id = 8
GROUP BY p.name
ORDER BY 次数 DESC, p.name
LIMIT 5;
