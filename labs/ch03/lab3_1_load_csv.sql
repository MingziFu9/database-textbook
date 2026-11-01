-- 实验 3-1：把 labs/data/csv/ 下的 8 个 CSV 导入 myshop。
-- 用 MySQL 命令行运行（要加 --local-infile=1），在 labs/ 目录下：
--   mysql -uroot -p --local-infile=1 --default-character-set=utf8mb4 < ch03/lab3_1_load_csv.sql
-- 用 DBeaver 的同学不用这个脚本，按教材步骤用“导入数据”向导。
-- 先导入被引用的表（类别、供应商、员工、顾客），再导入引用它们的表，否则外键会报错。
USE myshop;
LOAD DATA LOCAL INFILE 'data/csv/category.csv' INTO TABLE category
  CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES (category_id, name);
LOAD DATA LOCAL INFILE 'data/csv/supplier.csv' INTO TABLE supplier
  CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES (supplier_id, name, contact, phone, city);
LOAD DATA LOCAL INFILE 'data/csv/employee.csv' INTO TABLE employee
  CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES (employee_id, name, position, @manager_id, hire_date, salary)
  SET manager_id = NULLIF(@manager_id, '');
LOAD DATA LOCAL INFILE 'data/csv/customer.csv' INTO TABLE customer
  CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES (customer_id, name, gender, @phone, district, birth_year, reg_date)
  SET phone = NULLIF(@phone, '');
LOAD DATA LOCAL INFILE 'data/csv/member.csv' INTO TABLE member
  CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES (member_id, customer_id, level, points, join_date);
LOAD DATA LOCAL INFILE 'data/csv/product.csv' INTO TABLE product
  CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES (product_id, name, category_id, supplier_id, price, cost, stock, unit, description, shelf_date);
LOAD DATA LOCAL INFILE 'data/csv/orders.csv' INTO TABLE orders
  CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES (order_id, @customer_id, employee_id, order_time, pay_method, status)
  SET customer_id = NULLIF(@customer_id, '');
LOAD DATA LOCAL INFILE 'data/csv/order_item.csv' INTO TABLE order_item
  CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n'
  IGNORE 1 LINES (order_id, product_id, quantity, unit_price);
-- 核对：各表行数应为 8、8、8、200、123、48、2501、5811
SELECT 'category' AS 表, COUNT(*) AS 行数 FROM category UNION ALL SELECT 'supplier', COUNT(*) FROM supplier UNION ALL SELECT 'employee', COUNT(*) FROM employee UNION ALL SELECT 'customer', COUNT(*) FROM customer UNION ALL SELECT 'member', COUNT(*) FROM member UNION ALL SELECT 'product', COUNT(*) FROM product UNION ALL SELECT 'orders', COUNT(*) FROM orders UNION ALL SELECT 'order_item', COUNT(*) FROM order_item;
