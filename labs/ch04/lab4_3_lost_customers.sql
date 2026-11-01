-- 实验 4-3 找出“三个月没来过”的老顾客（示例库 shop，以 2026-06-30 为“今天”）
USE shop;

-- 第 1 步：每位顾客最后一次来是哪天、一共来过几次
SELECT customer_id,
       COUNT(*) AS 来店次数,
       DATE(MAX(order_time)) AS 最后一次
FROM orders
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY 最后一次
LIMIT 10;

-- 第 2 步：只留下“来过至少 5 次、但最近 3 个月没来”的顾客
SELECT customer_id,
       COUNT(*) AS 来店次数,
       DATE(MAX(order_time)) AS 最后一次,
       DATEDIFF('2026-06-30', MAX(order_time)) AS 多少天没来
FROM orders
WHERE customer_id IS NOT NULL
GROUP BY customer_id
HAVING COUNT(*) >= 5
   AND MAX(order_time) < DATE_SUB('2026-06-30', INTERVAL 3 MONTH)
ORDER BY 多少天没来 DESC;
