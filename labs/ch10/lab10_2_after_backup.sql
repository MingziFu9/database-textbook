-- 实验 10-2：备份完成之后，小店又卖出了一单（这一单不在全量备份里）
START TRANSACTION;
INSERT INTO orders (customer_id, employee_id, order_time, pay_method)
VALUES (1, 3, '2026-11-01 10:30:00', '微信');
SET @oid = LAST_INSERT_ID();
INSERT INTO order_item (order_id, product_id, quantity, unit_price)
VALUES (@oid, 8, 1, 26.90);
COMMIT;
SELECT order_id, customer_id, order_time FROM orders WHERE order_id = @oid;
