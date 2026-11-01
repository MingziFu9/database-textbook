---
title: 附录 A MySQL 常用 SQL 速查
description: 按用途整理的 MySQL 8.4 常用语句和函数：库与表、增删改查、连接与子查询、视图索引、事务与编程对象、用户权限与备份，每条注明对应章节
---

# 附录 A MySQL 常用 SQL 速查

按用途整理全书用到的语句，方括号 `[ ]` 表示可以省略的部分，示例都以小店示例库 shop 为准。忘了写法时先查这里，再顺着“见”栏回到正文看详细说明和例子。

## A.1 库和表 { #a1 }

| 用途 | 写法 | 见 |
|---|---|---|
| 建库 | `CREATE DATABASE [IF NOT EXISTS] myshop DEFAULT CHARACTER SET utf8mb4;` | 3.2.1 |
| 查看所有库 / 选库 | `SHOW DATABASES;`　`USE shop;` | 3.2 |
| 删库 | `DROP DATABASE [IF EXISTS] myshop;` | 3.2.2 |
| 建表 | `CREATE TABLE 表名 (列名 类型 [约束], ..., [表级约束]);` | 3.4.1 |
| 查看表 / 表结构 | `SHOW TABLES;`　`DESC product;`　`SHOW CREATE TABLE product;` | 3.4 |
| 加列 / 改列 / 删列 | `ALTER TABLE product ADD COLUMN barcode CHAR(13);`<br>`ALTER TABLE product MODIFY name VARCHAR(60) NOT NULL;`<br>`ALTER TABLE product DROP COLUMN barcode;` | 3.5.1 |
| 改表名 | `RENAME TABLE old_name TO new_name;` | 3.5.1 |
| 复制表 | `CREATE TABLE t2 LIKE t1;`（只复制结构）<br>`CREATE TABLE t2 AS SELECT * FROM t1;`（复制数据，不带主键外键） | 3.5.2 |
| 删表 / 清空 | `DROP TABLE [IF EXISTS] t;`　`TRUNCATE TABLE t;` | 3.5.3 |

**常用数据类型**（见 3.3）：整数 `INT`、`SMALLINT`、`TINYINT`；金额 `DECIMAL(8,2)`；定长字符串 `CHAR(11)`；变长字符串 `VARCHAR(40)`；长文本 `TEXT`；日期 `DATE`；日期时间 `DATETIME`；枚举 `ENUM('男','女')`。

**六种约束**（见 3.4.2）：

```sql
CREATE TABLE coupon (
  coupon_id   INT PRIMARY KEY AUTO_INCREMENT,                -- 主键 + 自动增长
  code        CHAR(8) NOT NULL UNIQUE,                       -- 非空 + 唯一
  amount      DECIMAL(6,2) NOT NULL CHECK (amount > 0),      -- 检查
  status      VARCHAR(10) NOT NULL DEFAULT '未使用',          -- 默认值
  customer_id INT,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id) -- 外键
    ON DELETE SET NULL                                       -- 参照动作（可省略，默认拒绝）
);
```

## A.2 增删改 { #a2 }

| 用途 | 写法 | 见 |
|---|---|---|
| 插入一行 | `INSERT INTO category (category_id, name) VALUES (9, '冷冻食品');` | 3.6.1 |
| 插入多行 | `INSERT INTO category VALUES (9, '冷冻食品'), (10, '母婴');` | 3.6.1 |
| 插入查询结果 | `INSERT INTO t2 SELECT ... FROM t1 WHERE ...;` | 3.6.1 |
| 修改 | `UPDATE product SET price = price * 1.05 WHERE category_id = 5;` | 3.6.2 |
| 删除 | `DELETE FROM orders WHERE order_id = 2502;` | 3.6.3 |
| 从 CSV 导入 | `LOAD DATA LOCAL INFILE 'data/csv/supplier.csv' INTO TABLE supplier CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;` | 3.7 |

!!! warning "UPDATE 和 DELETE 先写 WHERE"
    忘写 WHERE 会改掉或删掉整张表。养成习惯：先用 `SELECT * FROM 表 WHERE 条件` 看看会影响哪几行，确认后再把 SELECT 换成 UPDATE 或 DELETE（见 3.6.4）。

## A.3 单表查询 { #a3 }

完整的书写顺序（见 4.6）：

```sql
SELECT [DISTINCT] 列或表达式 [AS 别名], ...
FROM 表
[WHERE 行条件]
[GROUP BY 分组列]
[HAVING 分组条件]
[ORDER BY 列 [ASC|DESC], ...]
[LIMIT [跳过行数,] 行数];
```

执行顺序：FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT。所以 WHERE 里不能用聚合函数，也不能用 SELECT 里起的别名。

| 条件写法 | 例子 | 见 |
|---|---|---|
| 比较 | `price >= 20`　`status <> '已退款'` | 4.2.1 |
| 范围 | `price BETWEEN 10 AND 20`（含两端） | 4.2.2 |
| 列表 | `category_id IN (1, 2, 5)` | 4.2.2 |
| 模糊 | `name LIKE '%牛奶%'`（`%` 任意多个字符，`_` 一个字符） | 4.2.2 |
| 空值 | `customer_id IS NULL`　`IS NOT NULL`（不能写 `= NULL`） | 4.2.3 |
| 组合 | `AND`、`OR`、`NOT`，混用时加括号 | 4.2.4 |

## A.4 常用函数 { #a4 }

| 类别 | 函数 | 例子与结果 | 见 |
|---|---|---|---|
| 聚合 | `COUNT(*)`、`COUNT(列)`、`SUM`、`AVG`、`MAX`、`MIN` | `COUNT(*)` 数行数；`COUNT(列)` 不数 NULL | 4.5.1 |
| 字符串 | `CONCAT(a, b)`、`LENGTH(s)`（字节数）、`CHAR_LENGTH(s)`（字符数）、`LEFT(s, n)`、`SUBSTRING(s, 起点, 长度)`、`REPLACE(s, 旧, 新)`、`TRIM(s)`、`UPPER`/`LOWER` | `LEFT('10054751779', 3)` → `100` | 4.4.1 |
| 数值 | `ROUND(x, 2)`、`TRUNCATE(x, 2)`、`CEIL`、`FLOOR`、`ABS`、`MOD(a, b)` | `ROUND(3.456, 2)` → `3.46` | 4.4.2 |
| 日期 | `NOW()`、`CURDATE()`、`YEAR(d)`、`MONTH(d)`、`DAY(d)`、`DATE_FORMAT(d, '%Y-%m')`、`DATEDIFF(d1, d2)`、`DATE_ADD(d, INTERVAL 3 MONTH)`、`DATE_SUB` | `DATEDIFF('2026-06-30', '2026-06-01')` → `29` | 4.4.3 |
| 条件 | `IF(条件, 真值, 假值)`、`IFNULL(x, 替代值)`、`CASE WHEN ... THEN ... ELSE ... END` | `IFNULL(customer_id, 0)` | 4.4.4 |
| 窗口 | `ROW_NUMBER()`、`RANK()`、`DENSE_RANK()`、`LAG(列)`、`SUM(...) OVER (...)` | 见下 | 11.5 |

```sql
-- 窗口函数：每个类别内按售价排名（11.5 节）
SELECT name, category_id, price,
       RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS 类内名次
FROM product;
```

## A.5 多表查询 { #a5 }

| 用途 | 写法 | 见 |
|---|---|---|
| 内连接 | `SELECT ... FROM orders o JOIN customer c ON o.customer_id = c.customer_id` | 5.2 |
| 多表连接 | `FROM order_item i JOIN orders o ON i.order_id = o.order_id JOIN product p ON i.product_id = p.product_id` | 5.2.2 |
| 左外连接 | `FROM customer c LEFT JOIN orders o ON c.customer_id = o.customer_id`（左表全部保留，右边没有的填 NULL） | 5.3.2 |
| 找“没有的” | `... LEFT JOIN ... WHERE 右表.主键 IS NULL` | 5.3.2 |
| 全外连接 | MySQL 不支持 FULL JOIN，用 `左连接 UNION 右连接` | 5.3.3 |
| 自连接 | `FROM employee e JOIN employee m ON e.manager_id = m.employee_id` | 5.4 |
| 子查询（单值） | `WHERE price > (SELECT AVG(price) FROM product)` | 5.5.1 |
| 子查询（多值） | `WHERE customer_id IN (SELECT customer_id FROM member)` | 5.5.1 |
| 存在 | `WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id)` | 5.5.2 |
| 派生表 | `SELECT ... FROM (SELECT ... ) AS t`（必须起别名） | 5.5.3 |
| 合并结果 | `SELECT ... UNION [ALL] SELECT ...` | 5.6 |
| 分步写 | `WITH t AS (SELECT ...) SELECT ... FROM t;` | 5.7 |

!!! tip "NOT IN 遇到 NULL"
    子查询结果里只要有一个 NULL，`NOT IN` 就一行也查不出。用 `NOT IN` 时在子查询里加 `WHERE 列 IS NOT NULL`，或改用 `NOT EXISTS`、左连接。

## A.6 视图和索引 { #a6 }

| 用途 | 写法 | 见 |
|---|---|---|
| 建 / 改视图 | `CREATE [OR REPLACE] VIEW v_name AS SELECT ...;` | 8.1 |
| 带检查的视图 | `... WITH CHECK OPTION;` | 8.1.3 |
| 删视图 | `DROP VIEW v_name;` | 8.1 |
| 建索引 | `CREATE INDEX idx_orders_time ON orders(order_time);` | 8.3.1 |
| 唯一 / 组合索引 | `CREATE UNIQUE INDEX ...`　`CREATE INDEX idx_c_t ON orders(customer_id, order_time);` | 8.3 |
| 查看 / 删除索引 | `SHOW INDEX FROM orders;`　`DROP INDEX idx_orders_time ON orders;` | 8.3 |
| 执行计划 | `EXPLAIN SELECT ...;`（先看 type、key、rows 三列） | 8.4 |

## A.7 事务和数据库编程 { #a7 }

```sql
START TRANSACTION;               -- 开始事务（9.1）
UPDATE ...; INSERT ...;
COMMIT;                          -- 提交；出错时用 ROLLBACK 撤销

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;   -- 设置隔离级别（9.2）
SELECT @@transaction_isolation;                           -- 查看隔离级别

DELIMITER //                     -- 存储过程（9.4）
CREATE PROCEDURE p_name(IN 参数 INT, OUT 结果 DECIMAL(10,2))
BEGIN
  DECLARE 变量 INT DEFAULT 0;
  IF 条件 THEN ... ELSEIF ... ELSE ... END IF;
  SELECT ... INTO 结果 FROM ...;
END //
DELIMITER ;
CALL p_name(5, @r);  SELECT @r;

CREATE TRIGGER trg_name AFTER INSERT ON order_item   -- 触发器（9.5）
FOR EACH ROW UPDATE product SET stock = stock - NEW.quantity WHERE product_id = NEW.product_id;

CREATE EVENT ev_name ON SCHEDULE EVERY 1 DAY STARTS '2026-07-01 02:00:00'   -- 事件（9.6）
DO DELETE FROM log WHERE created < NOW() - INTERVAL 90 DAY;
```

## A.8 用户、权限和备份 { #a8 }

| 用途 | 写法 | 见 |
|---|---|---|
| 建用户 | `CREATE USER 'clerk'@'localhost' IDENTIFIED BY '口令';` | 10.4.1 |
| 授权 | `GRANT SELECT, INSERT ON shop.orders TO 'clerk'@'localhost';` | 10.4.2 |
| 列级授权 | `GRANT SELECT (customer_id, name) ON shop.customer TO ...;` | 10.4.2 |
| 收回 | `REVOKE INSERT ON shop.orders FROM 'clerk'@'localhost';` | 10.4.2 |
| 查看权限 | `SHOW GRANTS FOR 'clerk'@'localhost';` | 10.4.2 |
| 角色 | `CREATE ROLE r_cashier;`　`GRANT r_cashier TO 'clerk'@'localhost';`　`SET DEFAULT ROLE ALL TO 'clerk'@'localhost';` | 10.4.3 |
| 改口令 / 锁定 | `ALTER USER 'clerk'@'localhost' IDENTIFIED BY '新口令';`　`ALTER USER ... ACCOUNT LOCK;` | 10.4.4 |
| 删用户 | `DROP USER 'clerk'@'localhost';` | 10.4 |
| 逻辑备份（命令行） | `mysqldump -u root -p --single-transaction --routines --triggers --databases shop > shop.sql` | 10.5.2 |
| 恢复（命令行） | `mysql -u root -p < shop.sql` | 10.5.2 |
| 二进制日志 | `SHOW BINARY LOGS;`　`mysqlbinlog --start-position=... --stop-position=... 日志文件 \| mysql -u root -p` | 10.5.3 |

## A.9 MySQL 和 PostgreSQL 写法差异 { #a9 }

下表摘自 10.2.4 节，每一条编者都在 MySQL 8.4 和 PostgreSQL 17 上实际运行过：

| 写法 | MySQL 8.4 | PostgreSQL 17 |
|---|---|---|
| 自增编号 | `AUTO_INCREMENT` | `GENERATED BY DEFAULT AS IDENTITY`（或旧写法 `SERIAL`） |
| 日期格式化 | `DATE_FORMAT(order_time, '%Y-%m')` | `TO_CHAR(order_time, 'YYYY-MM')` |
| 空值替换 | `IFNULL(x, '无')` 或 `COALESCE` | 只有 `COALESCE(x, '无')` |
| 字符串拼接 | `CONCAT(a, b)`；`a \|\| b` 是“或”运算，结果是 0 | `CONCAT(a, b)` 或 `a \|\| b` |
| 整数相除 `7 / 2` | 3.5000 | 3（写成 `7.0 / 2` 才得 3.5） |
| `'abc' = 'ABC'` | 1（默认不区分大小写） | f（区分大小写） |
| 名字加引号 | 反引号 `` `name` `` | 双引号 `"name"` |
| 插入后取新编号 | `SELECT LAST_INSERT_ID();` | `INSERT … RETURNING customer_id;` |
| 看表结构 | `DESC t;` | `\d t`（psql 命令） |
| 向量相似度 | 社区版 8.4 没有 | pgvector：`ORDER BY embedding <=> '[...]' LIMIT 3`（余弦距离，见 12.5 节） |
