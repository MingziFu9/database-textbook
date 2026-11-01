-- 实验 5-1 四种连接对比：用两张很小的表看清楚哪些行留下、哪些行变空
DROP DATABASE IF EXISTS joindemo;
CREATE DATABASE joindemo DEFAULT CHARACTER SET utf8mb4;
USE joindemo;

-- 4 位顾客，其中“赵六”一单也没买过
CREATE TABLE customer (
  customer_id INT PRIMARY KEY,
  name        VARCHAR(20) NOT NULL
);
INSERT INTO customer VALUES (1, '张三'), (2, '李四'), (3, '王五'), (4, '赵六');

-- 5 笔订单，其中 104 是散客（没有顾客编号），105 的顾客编号 9 在顾客表里找不到（录错了）
-- 为了演示，这里故意没有加外键约束
CREATE TABLE orders (
  order_id    INT PRIMARY KEY,
  customer_id INT,
  amount      DECIMAL(8,2)
);
INSERT INTO orders VALUES (101, 1, 35.00), (102, 1, 12.50), (103, 2, 88.00), (104, NULL, 9.90), (105, 9, 20.00);

-- 1. 内连接：只留两边都对得上的
SELECT c.customer_id, c.name, o.order_id, o.amount
FROM customer c
INNER JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_id;

-- 2. 左外连接：左表（顾客）全留，右边对不上的填 NULL
SELECT c.customer_id, c.name, o.order_id, o.amount
FROM customer c
LEFT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_id;

-- 3. 右外连接：右表（订单）全留，左边对不上的填 NULL
SELECT c.customer_id, c.name, o.order_id, o.amount
FROM customer c
RIGHT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- 4. 全外连接：两边都全留。MySQL 不支持 FULL JOIN，用左连接 UNION 右连接代替
SELECT c.customer_id, c.name, o.order_id, o.amount
FROM customer c LEFT JOIN orders o ON o.customer_id = c.customer_id
UNION
SELECT c.customer_id, c.name, o.order_id, o.amount
FROM customer c RIGHT JOIN orders o ON o.customer_id = c.customer_id;

-- 5. 忘了写连接条件：笛卡尔积，4 × 5 = 20 行
SELECT COUNT(*) AS 行数 FROM customer, orders;
