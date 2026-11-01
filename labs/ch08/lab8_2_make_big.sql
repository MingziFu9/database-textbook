-- 实验 8-2 第 1 步：造一张 100 万行的订单表（在普通笔记本上约需 10～60 秒）
DROP DATABASE IF EXISTS bigshop;
CREATE DATABASE bigshop DEFAULT CHARACTER SET utf8mb4;
USE bigshop;

-- 0～9 十个数字，用来“乘”出 100 万行
CREATE TABLE digits (d INT PRIMARY KEY);
INSERT INTO digits VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

CREATE TABLE orders_big (
  order_id    INT PRIMARY KEY,
  customer_id INT NOT NULL,
  phone       CHAR(11) NOT NULL,
  order_time  DATETIME NOT NULL,
  pay_method  VARCHAR(10) NOT NULL,
  amount      DECIMAL(8,2) NOT NULL
);

-- 6 个 digits 交叉连接 = 10^6 种组合，每种组合算出一个订单号 n（1～1000000）
-- 其余各列用 n 算出“看起来随机”的值：顾客 2 万位，时间分布在 2023—2026 年
INSERT INTO orders_big
SELECT n,
       1 + MOD(n * 7919, 20000)                               AS customer_id,
       CONCAT('100', LPAD(MOD((1 + MOD(n * 7919, 20000)) * 104729, 100000000), 8, '0')) AS phone,
       '2023-01-01' + INTERVAL MOD(n * 2654435761, 1277 * 86400) SECOND AS order_time,
       ELT(1 + MOD(n * 31, 4), '微信', '支付宝', '现金', '银行卡') AS pay_method,
       ROUND(5 + MOD(n * 15485863, 30000) / 100, 2)           AS amount
FROM (SELECT a.d + b.d * 10 + c.d * 100 + e.d * 1000 + f.d * 10000 + g.d * 100000 + 1 AS n
      FROM digits a, digits b, digits c, digits e, digits f, digits g) t;

SELECT COUNT(*) AS 行数, MIN(order_time), MAX(order_time), COUNT(DISTINCT customer_id) AS 顾客数
FROM orders_big;
