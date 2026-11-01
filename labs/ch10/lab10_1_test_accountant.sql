-- 实验 10-1：用会计账号 accountant 登录后逐条运行
SELECT * FROM v_monthly_sales WHERE month >= '2026-04';          -- 看月报：可以
SELECT COUNT(*) FROM orders;                                     -- 数订单：可以
INSERT INTO orders (customer_id, employee_id, order_time)
VALUES (1, 3, NOW());                                            -- 录订单：不行
SELECT name FROM customer LIMIT 1;                               -- 看顾客：不行
