-- 实验 9-2 会话 B（在第二个 SQL 编辑器窗口里执行，DBeaver 里要打开“新建脚本”并确认是单独的连接）
USE txshop;

-- 步骤 1：把隔离级别降到最低：读未提交
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT @@transaction_isolation;
-- 步骤 3：A 改了价但没提交，B 读到了吗？
SELECT price FROM product WHERE product_id = 14;
-- 步骤 5：A 撤销以后再读
SELECT price FROM product WHERE product_id = 14;
-- （把隔离级别改成读已提交，重做步骤 2～5，看步骤 3 读到的是多少）
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 步骤 6：（读已提交）开始事务，第一次读价格
START TRANSACTION;
SELECT price FROM product WHERE product_id = 14;
-- 步骤 8：同一个事务里第二次读，A 已经改价并提交
SELECT price FROM product WHERE product_id = 14;
COMMIT;
-- （把隔离级别改成可重复读，即 MySQL 默认值，重做步骤 6～9，看步骤 8 读到的是多少）
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- 步骤 10：锁等待最多等 5 秒（默认 50 秒）
SET SESSION innodb_lock_wait_timeout = 5;
-- 步骤 12：A 正在改这一行还没提交，B 也来改
UPDATE product SET stock = stock - 1 WHERE product_id = 8;
