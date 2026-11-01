-- 实验 10-1：用店员账号 clerk 登录后逐条运行，记下哪些成功、哪些报错
SELECT CURRENT_USER(), CURRENT_ROLE();
SELECT name, price, stock FROM product WHERE product_id = 8;     -- 查商品：可以
SELECT customer_id, name FROM customer WHERE customer_id = 1;    -- 查顾客姓名：可以
SELECT name, phone FROM customer WHERE customer_id = 1;          -- 查手机号：不行
UPDATE product SET price = 1 WHERE product_id = 8;               -- 改价格：不行
SELECT * FROM employee;                                          -- 看员工工资：不行
DELETE FROM orders WHERE order_id = 1;                           -- 删订单：不行
