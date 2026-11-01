-- 实验 3-2：修改表结构、增删改数据（在 myshop 里做，不影响示例库 shop）
USE myshop;
-- 1 给商品表加一列“条形码”，放在名称后面
ALTER TABLE product ADD COLUMN barcode CHAR(13) AFTER name;
-- 2 新到一种商品：桂林米粉（类别 1，供应商 1），条形码 6900000000017
INSERT INTO product (name, barcode, category_id, supplier_id, price, cost, stock, unit)
VALUES ('桂林米粉 1kg', '6900000000017', 1, 1, 18.80, 13.00, 40, '袋');
-- 3 查看刚插入的那一行（LAST_INSERT_ID() 返回最近一次自增生成的编号）
SELECT product_id, name, barcode, price, stock FROM product WHERE product_id = LAST_INSERT_ID();
-- 4 先查后改：看看“饮料”类（类别 4）现在的价格
SELECT product_id, name, price FROM product WHERE category_id = 4;
-- 5 夏季促销：饮料类一律打九五折
UPDATE product SET price = ROUND(price * 0.95, 2) WHERE category_id = 4;
SELECT product_id, name, price FROM product WHERE category_id = 4;
-- 6 补货：挂面（编号 5）进了 60 袋
UPDATE product SET stock = stock + 60 WHERE product_id = 5;
SELECT name, stock FROM product WHERE product_id = 5;
-- 7 桂林米粉录错了，删除它（先 SELECT 确认只有 1 行，再 DELETE）
SELECT product_id, name FROM product WHERE name = '桂林米粉 1kg';
DELETE FROM product WHERE name = '桂林米粉 1kg';
-- 8 删掉条形码列，恢复原样
ALTER TABLE product DROP COLUMN barcode;
SELECT COUNT(*) AS 商品数 FROM product;
