-- 实验 7-1（上机部分）用 SQL 检查函数依赖在数据里是否成立
-- 先运行 lab7_2_decompose.sql 的第 1 步，建好 normdemo.order_wide
-- 检查“A → B”的方法：按 A 分组，看有没有哪一组里 B 有两个以上不同的值
USE normdemo;

-- 1. customer_id → customer_name：一个顾客编号只对应一个姓名吗？
SELECT 'customer_id → customer_name' AS 依赖, COUNT(*) AS 违反的组数
FROM (SELECT customer_id FROM order_wide
      GROUP BY customer_id HAVING COUNT(DISTINCT customer_name) > 1) t
UNION ALL
-- 2. product_id → category_name
SELECT 'product_id → category_name', COUNT(*)
FROM (SELECT product_id FROM order_wide
      GROUP BY product_id HAVING COUNT(DISTINCT category_name) > 1) t
UNION ALL
-- 3. order_id → customer_id
SELECT 'order_id → customer_id', COUNT(*)
FROM (SELECT order_id FROM order_wide
      GROUP BY order_id HAVING COUNT(DISTINCT customer_id) > 1) t
UNION ALL
-- 4. order_id → product_id（一张订单只买一种商品？）
SELECT 'order_id → product_id', COUNT(*)
FROM (SELECT order_id FROM order_wide
      GROUP BY order_id HAVING COUNT(DISTINCT product_id) > 1) t
UNION ALL
-- 5. category_name → product_name（一个类别只有一种商品？）
SELECT 'category_name → product_name', COUNT(*)
FROM (SELECT category_name FROM order_wide
      GROUP BY category_name HAVING COUNT(DISTINCT product_name) > 1) t
UNION ALL
-- 6. product_id → unit_price（同一种商品在所有订单里单价都一样？）
SELECT 'product_id → unit_price', COUNT(*)
FROM (SELECT product_id FROM order_wide
      GROUP BY product_id HAVING COUNT(DISTINCT unit_price) > 1) t;
