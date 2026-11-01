-- 实验 9-1 用事务完成下单（在 txshop 里做；命令行或 DBeaver 都可以，逐条执行）
USE txshop;

-- ① 成功的下单：顾客 1 买 2 袋燕麦片（商品 8），收银员 3
START TRANSACTION;
UPDATE product SET stock = stock - 2 WHERE product_id = 8;
INSERT INTO orders (customer_id, employee_id, order_time, pay_method, status)
VALUES (1, 3, '2026-07-01 08:15:00', '微信', '已完成');
INSERT INTO order_item (order_id, product_id, quantity, unit_price)
VALUES (LAST_INSERT_ID(), 8, 2, 26.90);
COMMIT;
SELECT stock FROM product WHERE product_id = 8;                -- 91 - 2 = 89
SELECT order_id, customer_id, order_time FROM orders ORDER BY order_id DESC LIMIT 1;

-- ② 中途出错：扣了库存，写明细时商品编号写错了（999 不存在）
START TRANSACTION;
UPDATE product SET stock = stock - 1 WHERE product_id = 14;
SELECT stock FROM product WHERE product_id = 14;               -- 事务里看到 7
INSERT INTO order_item (order_id, product_id, quantity, unit_price)
VALUES (2502, 999, 1, 8.90);                                   -- 报错 1452
ROLLBACK;                                                      -- 发现出错，全部撤销
SELECT stock FROM product WHERE product_id = 14;               -- 回到 8

-- ③ 超卖：挂面（商品 5）库存是 0，还想卖 1 包
START TRANSACTION;
UPDATE product SET stock = stock - 1 WHERE product_id = 5;     -- 违反 chk_stock，报错 3819
ROLLBACK;
SELECT stock FROM product WHERE product_id = 5;
