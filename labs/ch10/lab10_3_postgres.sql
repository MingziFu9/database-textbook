-- 实验 10-3：在 PostgreSQL 的 shop 库里运行（psql 或 pgAdmin），和 MySQL 的结果对照
-- ① 按月统计 2026 年上半年的订单数：DATE_FORMAT 换成 TO_CHAR
SELECT TO_CHAR(order_time, 'YYYY-MM') AS month, COUNT(*) AS orders
FROM orders WHERE order_time >= '2026-01-01' AND order_time < '2026-07-01'
GROUP BY month ORDER BY month;
-- ② 两个整数相除
SELECT 7 / 2 AS result, 7.0 / 2 AS result2;
-- ③ 大小写不同的字符串比较
SELECT 'abc' = 'ABC' AS same;
-- ④ 字符串拼接
SELECT CONCAT(name, '（', unit, '）') AS item FROM product WHERE product_id = 8;
SELECT name || unit AS item FROM product WHERE product_id = 8;
-- ⑤ 空值替换：IFNULL 在 PostgreSQL 里没有
SELECT COALESCE(NULL, '无') AS b;
SELECT IFNULL(NULL, '无') AS a;
-- ⑥ 名字要用双引号，反引号会报错
SELECT "name" FROM "product" WHERE product_id = 8;
SELECT `name` FROM `product` WHERE product_id = 8;
-- ⑦ 插入时直接返回新编号
INSERT INTO customer (name, gender, reg_date) VALUES ('测试顾客', '女', CURRENT_DATE)
RETURNING customer_id;
DELETE FROM customer WHERE name = '测试顾客';
