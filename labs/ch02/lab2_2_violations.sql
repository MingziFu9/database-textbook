-- 实验 2-2：故意违反三类完整性（每条都会被 MySQL 拒绝，数据不会被改）
USE shop;
-- 1 实体完整性：主键为空
INSERT INTO category (category_id, name) VALUES (NULL, '冷冻食品');
-- 2 实体完整性：主键重复（1 号已是“粮油米面”）
INSERT INTO category (category_id, name) VALUES (1, '冷冻食品');
-- 3 参照完整性：不存在的 999 号顾客下单
INSERT INTO orders (customer_id, employee_id, order_time) VALUES (999, 3, '2026-06-30 10:00:00');
-- 4 参照完整性：删除还有商品在用的 1 号类别
DELETE FROM category WHERE category_id = 1;
-- 5 用户定义完整性：价格为负（CHECK 约束）
UPDATE product SET price = -5 WHERE product_id = 1;
-- 6 用户定义完整性：性别只能是“男”或“女”（ENUM）
INSERT INTO customer (name, gender, reg_date) VALUES ('测试', '未知', '2026-06-30');
-- 7 用户定义完整性：类别名不能重复（UNIQUE）
INSERT INTO category (category_id, name) VALUES (9, '饮料');
