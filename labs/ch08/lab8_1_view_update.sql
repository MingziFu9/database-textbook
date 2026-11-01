-- 实验 8-1 第 4 步：通过视图修改数据（在 myshop 里做，不动示例库 shop）
USE myshop;

-- 只包含“饮料”的视图，加 WITH CHECK OPTION：通过视图改的数据必须仍然满足视图的条件
CREATE OR REPLACE VIEW v_drinks AS
SELECT product_id, name, price, category_id
FROM product
WHERE category_id = 4
WITH CHECK OPTION;

-- 1. 通过视图改价格：可以，改的其实是 product 表
UPDATE v_drinks SET price = 4.80 WHERE name LIKE '无糖绿茶%';
SELECT product_id, name, price FROM product WHERE name LIKE '无糖绿茶%';

-- 2. 通过视图把饮料改成别的类别：违反视图条件，被拒绝
UPDATE v_drinks SET category_id = 3 WHERE name LIKE '无糖绿茶%';

-- 3. 带 GROUP BY 的视图不能修改
CREATE OR REPLACE VIEW v_cat_count AS
SELECT category_id, COUNT(*) AS n FROM product GROUP BY category_id;
UPDATE v_cat_count SET n = 10 WHERE category_id = 1;
