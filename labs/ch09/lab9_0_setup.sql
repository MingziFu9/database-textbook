-- 第 9 章实验准备：从示例库 shop 复制出一个练习库 txshop（第 9 章的实验都在这里做，随时可以重新运行本脚本还原）
DROP DATABASE IF EXISTS txshop;
CREATE DATABASE txshop DEFAULT CHARACTER SET utf8mb4;
USE txshop;

CREATE TABLE employee   LIKE shop.employee;    INSERT INTO employee   SELECT * FROM shop.employee;
CREATE TABLE customer   LIKE shop.customer;    INSERT INTO customer   SELECT * FROM shop.customer;
CREATE TABLE product    LIKE shop.product;     INSERT INTO product    SELECT * FROM shop.product;
CREATE TABLE orders     LIKE shop.orders;      INSERT INTO orders     SELECT * FROM shop.orders;
CREATE TABLE order_item LIKE shop.order_item;  INSERT INTO order_item SELECT * FROM shop.order_item;

-- LIKE 不复制外键，补上；再加一条“库存不能为负”的检查约束
ALTER TABLE orders     ADD FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
                       ADD FOREIGN KEY (employee_id) REFERENCES employee(employee_id);
ALTER TABLE order_item ADD FOREIGN KEY (order_id)   REFERENCES orders(order_id),
                       ADD FOREIGN KEY (product_id) REFERENCES product(product_id);
ALTER TABLE product    ADD CONSTRAINT chk_stock CHECK (stock >= 0);

SELECT product_id, name, price, stock FROM product WHERE product_id IN (5, 8, 14);
