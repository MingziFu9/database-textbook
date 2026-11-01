-- 实验 5-2 用连接和子查询完成小店的八个查询（示例库 shop）
USE shop;

-- 查询 1：王芳（顾客 81）2026 年 5 月买了哪些东西？（四表连接）
SELECT o.order_id, o.order_time, p.name AS 商品, oi.quantity AS 数量, oi.unit_price AS 单价
FROM customer c
JOIN orders o      ON o.customer_id = c.customer_id
JOIN order_item oi ON oi.order_id = o.order_id
JOIN product p     ON p.product_id = oi.product_id
WHERE c.customer_id = 81
  AND o.order_time >= '2026-05-01' AND o.order_time < '2026-06-01'
ORDER BY o.order_time;

-- 查询 2：金额最大的 5 笔订单，显示顾客姓名（散客显示“散客”）
SELECT o.order_id, IFNULL(c.name, '散客') AS 顾客, SUM(oi.quantity * oi.unit_price) AS 金额
FROM orders o
LEFT JOIN customer c ON c.customer_id = o.customer_id
JOIN order_item oi   ON oi.order_id = o.order_id
GROUP BY o.order_id, c.name
ORDER BY 金额 DESC
LIMIT 5;

-- 查询 3：每个类别的销售额（只算已完成订单）
SELECT cat.name AS 类别, SUM(oi.quantity * oi.unit_price) AS 销售额
FROM order_item oi
JOIN orders o     ON o.order_id = oi.order_id
JOIN product p    ON p.product_id = oi.product_id
JOIN category cat ON cat.category_id = p.category_id
WHERE o.status = '已完成'
GROUP BY cat.name
ORDER BY 销售额 DESC;

-- 查询 4：2026 年每个月的销售额（只算已完成订单）
SELECT DATE_FORMAT(o.order_time, '%Y-%m') AS 月份, SUM(oi.quantity * oi.unit_price) AS 销售额
FROM orders o
JOIN order_item oi ON oi.order_id = o.order_id
WHERE o.status = '已完成' AND o.order_time >= '2026-01-01'
GROUP BY 月份
ORDER BY 月份;

-- 查询 5：注册了但从来没买过东西的顾客有多少位？（左连接 + IS NULL）
SELECT COUNT(*) AS 没买过的顾客
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- 查询 6：售价高于全店平均售价的商品（子查询）
SELECT name, price
FROM product
WHERE price > (SELECT AVG(price) FROM product)
ORDER BY price DESC;

-- 查询 7：每位员工和他的上级（自连接）
SELECT e.name AS 员工, e.position AS 职位, m.name AS 上级
FROM employee e
LEFT JOIN employee m ON m.employee_id = e.manager_id
ORDER BY e.employee_id;

-- 查询 8：积分最高的 5 位金卡会员的姓名、电话和积分
SELECT c.name, c.phone, m.points
FROM customer c
JOIN member m ON m.customer_id = c.customer_id
WHERE m.level = '金卡'
ORDER BY m.points DESC
LIMIT 5;
