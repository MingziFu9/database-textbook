-- 实验 8-3 找出并改写五条“慢 SQL”（先完成实验 8-2，表上已有 idx_customer、idx_phone、idx_cust_time）
USE bigshop;
CREATE INDEX idx_time ON orders_big (order_time);      -- 再给下单时间建一个索引

-- 慢 1：对列用了函数
EXPLAIN SELECT COUNT(*) FROM orders_big WHERE DATE(order_time) = '2026-06-30';
SELECT COUNT(*) FROM orders_big WHERE DATE(order_time) = '2026-06-30';
-- 快 1：改成范围条件，列保持“干净”
EXPLAIN SELECT COUNT(*) FROM orders_big WHERE order_time >= '2026-06-30' AND order_time < '2026-07-01';
SELECT COUNT(*) FROM orders_big WHERE order_time >= '2026-06-30' AND order_time < '2026-07-01';

-- 慢 2：隐式类型转换（phone 是字符串，却和数字比较）
EXPLAIN SELECT * FROM orders_big WHERE phone = 10005864824;
SELECT COUNT(*) FROM orders_big WHERE phone = 10005864824;
-- 快 2：加上引号
EXPLAIN SELECT * FROM orders_big WHERE phone = '10005864824';
SELECT COUNT(*) FROM orders_big WHERE phone = '10005864824';

-- 慢 3：以 % 开头的 LIKE
EXPLAIN SELECT * FROM orders_big WHERE phone LIKE '%64824';
SELECT COUNT(*) FROM orders_big WHERE phone LIKE '%64824';
-- 快 3：如果业务允许，按开头匹配
EXPLAIN SELECT * FROM orders_big WHERE phone LIKE '1000586%';
SELECT COUNT(*) FROM orders_big WHERE phone LIKE '1000586%';

-- 慢 4：OR 的一边没有索引
EXPLAIN SELECT * FROM orders_big WHERE customer_id = 12345 OR amount > 304.9;
SELECT COUNT(*) FROM orders_big WHERE customer_id = 12345 OR amount > 304.9;
-- 快 4：给 amount 建索引后，MySQL 会把两个索引的结果合并（index_merge）
CREATE INDEX idx_amount ON orders_big (amount);
EXPLAIN SELECT * FROM orders_big WHERE customer_id = 12345 OR amount > 304.9;
SELECT COUNT(*) FROM orders_big WHERE customer_id = 12345 OR amount > 304.9;

-- 慢 5：组合索引 (customer_id, order_time) 跳过了第一列（先删掉单独的 idx_time，模拟只有组合索引的情况）
DROP INDEX idx_time ON orders_big;
EXPLAIN SELECT * FROM orders_big WHERE order_time >= '2026-06-30';
SELECT COUNT(*), SUM(amount) FROM orders_big WHERE order_time >= '2026-06-30';
-- 快 5：条件里带上组合索引的第一列（最左前缀）
EXPLAIN SELECT * FROM orders_big WHERE customer_id = 12345 AND order_time >= '2026-06-01';
SELECT COUNT(*), SUM(amount) FROM orders_big WHERE customer_id = 12345 AND order_time >= '2026-06-01';
