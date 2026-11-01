-- 实验 10-1：收回权限、锁定账号（用 root 运行）
REVOKE INSERT ON shop.orders FROM r_clerk;           -- 店员不再能录订单
SHOW GRANTS FOR 'clerk'@'%' USING r_clerk;
ALTER USER 'clerk'@'%' ACCOUNT LOCK;                 -- 店员离职：锁定账号
SELECT user, host, account_locked FROM mysql.user WHERE user IN ('boss','clerk','accountant');

-- 恢复（想重做实验时运行）：
-- ALTER USER 'clerk'@'%' ACCOUNT UNLOCK;
-- GRANT INSERT ON shop.orders TO r_clerk;
