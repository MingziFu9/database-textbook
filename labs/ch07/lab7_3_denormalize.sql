-- 实验 7-3 反规范化：给订单表加一列“订单总金额”，看看好处和代价
USE normdemo;
DROP TABLE IF EXISTS orders_t, item_t;
CREATE TABLE orders_t AS SELECT order_id, customer_id, order_time, status FROM shop.orders;
CREATE TABLE item_t   AS SELECT * FROM shop.order_item;
ALTER TABLE orders_t ADD PRIMARY KEY (order_id);
ALTER TABLE item_t   ADD PRIMARY KEY (order_id, product_id);

-- 1. 规范化的做法：每次都从明细算
SELECT o.order_id, SUM(i.quantity * i.unit_price) AS 总金额
FROM orders_t o JOIN item_t i ON i.order_id = o.order_id
WHERE o.order_id = 2499
GROUP BY o.order_id;

-- 2. 反规范化：加一列 total_amount，把算好的结果存起来
ALTER TABLE orders_t ADD COLUMN total_amount DECIMAL(10,2);
UPDATE orders_t o
JOIN (SELECT order_id, SUM(quantity * unit_price) AS amt FROM item_t GROUP BY order_id) s
  ON s.order_id = o.order_id
SET o.total_amount = s.amt;
SELECT order_id, total_amount FROM orders_t WHERE order_id = 2499;   -- 查询不用连接了

-- 3. 代价：有人改了明细（顾客退了一个豆腐），却忘了改总金额
UPDATE item_t SET quantity = quantity - 1 WHERE order_id = 2499 AND product_id = 41;

-- 4. 两边对不上了：找出存的总金额和明细算出来的不一致的订单
SELECT o.order_id, o.total_amount AS 存的总金额, SUM(i.quantity * i.unit_price) AS 明细算出的
FROM orders_t o JOIN item_t i ON i.order_id = o.order_id
GROUP BY o.order_id, o.total_amount
HAVING o.total_amount <> SUM(i.quantity * i.unit_price);
