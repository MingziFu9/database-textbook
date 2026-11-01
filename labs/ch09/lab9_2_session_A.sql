-- 实验 9-2 会话 A（在第一个 SQL 编辑器窗口里执行）。按“步骤号”和会话 B 交替执行，一次只执行一步！
USE txshop;
-- 步骤 0：确认商品 14（原味薯片）的价格是 8.90
SELECT price FROM product WHERE product_id = 14;

-- ===== 场景 1、2：脏读 =====
-- 步骤 2：开始事务，把价格改成 9.90，但先不提交
START TRANSACTION;
UPDATE product SET price = 9.90 WHERE product_id = 14;
-- 步骤 4：反悔了，撤销
ROLLBACK;

-- ===== 场景 3、4：不可重复读 =====
-- 步骤 7：直接改价（自动提交）
UPDATE product SET price = 9.90 WHERE product_id = 14;
-- 步骤 9：改回原价，准备下一个场景
UPDATE product SET price = 8.90 WHERE product_id = 14;

-- ===== 场景 5：锁等待 =====
-- 步骤 11：开始事务，修改燕麦片的库存，先不提交
START TRANSACTION;
UPDATE product SET stock = stock - 1 WHERE product_id = 8;
-- 步骤 13：撤销，释放锁
ROLLBACK;
