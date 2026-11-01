-- 实验 8-2 第 2 步：加索引前后对比（逐条执行，记下每条语句的耗时）
USE bigshop;

-- 1. 没有索引：查顾客 12345 的全部订单
SELECT COUNT(*), SUM(amount) FROM orders_big WHERE customer_id = 12345;
EXPLAIN SELECT * FROM orders_big WHERE customer_id = 12345;

-- 2. 给 customer_id 建索引（建索引本身也要花时间）
CREATE INDEX idx_customer ON orders_big (customer_id);

-- 3. 有了索引，再查一次
SELECT COUNT(*), SUM(amount) FROM orders_big WHERE customer_id = 12345;
EXPLAIN SELECT * FROM orders_big WHERE customer_id = 12345;

-- 4. 按手机号查：没有索引 → 建唯一索引不行（同一顾客的电话重复出现），建普通索引
SELECT COUNT(*) FROM orders_big WHERE phone = '10005864824';
CREATE INDEX idx_phone ON orders_big (phone);
SELECT COUNT(*) FROM orders_big WHERE phone = '10005864824';

-- 5. 组合索引：查某位顾客 2026 年的订单
CREATE INDEX idx_cust_time ON orders_big (customer_id, order_time);
EXPLAIN SELECT * FROM orders_big
WHERE customer_id = 12345 AND order_time >= '2026-01-01';

-- 6. 看看表上有哪些索引、数据和索引各占多大（先 ANALYZE 更新统计信息）
SHOW INDEX FROM orders_big;
ANALYZE TABLE orders_big;
SELECT ROUND(data_length / 1024 / 1024, 1) AS 数据MB, ROUND(index_length / 1024 / 1024, 1) AS 索引MB
FROM information_schema.tables
WHERE table_schema = 'bigshop' AND table_name = 'orders_big';

-- 7. 索引的代价：往有 3 个二级索引的表和没有索引的表里各插入 20 万行，比较耗时
CREATE TABLE copy_noidx LIKE orders_big;
ALTER TABLE copy_noidx DROP INDEX idx_customer, DROP INDEX idx_phone, DROP INDEX idx_cust_time;
CREATE TABLE copy_idx LIKE orders_big;
INSERT INTO copy_noidx SELECT * FROM orders_big WHERE order_id <= 200000;
INSERT INTO copy_idx   SELECT * FROM orders_big WHERE order_id <= 200000;
DROP TABLE copy_noidx, copy_idx;
