-- 实验 10-3：在 MySQL 里运行，和 lab10_3_postgres.sql 的结果对照
-- ① 按月统计 2026 年上半年的订单数
SELECT DATE_FORMAT(order_time, '%Y-%m') AS month, COUNT(*) AS orders
FROM orders WHERE order_time >= '2026-01-01' AND order_time < '2026-07-01'
GROUP BY month ORDER BY month;
-- ② 两个整数相除
SELECT 7 / 2 AS result;
-- ③ 大小写不同的字符串比较
SELECT 'abc' = 'ABC' AS same;
-- ④ 字符串拼接
SELECT CONCAT(name, '（', unit, '）') AS item FROM product WHERE product_id = 8;
SELECT name || unit AS item FROM product WHERE product_id = 8;
-- ⑤ 空值替换
SELECT IFNULL(NULL, '无') AS a, COALESCE(NULL, '无') AS b;
-- ⑥ 反引号括起的名字
SELECT `name` FROM `product` WHERE product_id = 8;
-- ⑦ 插入后取得新编号
INSERT INTO customer (name, gender, reg_date) VALUES ('测试顾客', '女', CURDATE());
SELECT LAST_INSERT_ID() AS customer_id;
DELETE FROM customer WHERE name = '测试顾客';
