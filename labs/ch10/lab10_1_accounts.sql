-- 实验 10-1：为老板、店员、会计建三个账号并授权（用 root 运行）
-- 先删掉旧的，方便重复运行
DROP USER IF EXISTS 'boss'@'%', 'clerk'@'%', 'accountant'@'%';
DROP ROLE IF EXISTS r_boss, r_clerk, r_accountant;

-- ① 建三个角色，把权限给角色
CREATE ROLE r_boss, r_clerk, r_accountant;

GRANT ALL PRIVILEGES ON shop.* TO r_boss;                -- 老板：shop 库里什么都能做

GRANT SELECT ON shop.product  TO r_clerk;                -- 店员：查商品
GRANT SELECT ON shop.category TO r_clerk;
GRANT SELECT, INSERT ON shop.orders     TO r_clerk;      -- 店员：录订单
GRANT SELECT, INSERT ON shop.order_item TO r_clerk;
GRANT SELECT (customer_id, name) ON shop.customer TO r_clerk;  -- 只能看顾客编号和姓名

GRANT SELECT ON shop.orders          TO r_accountant;    -- 会计：只读订单和报表
GRANT SELECT ON shop.order_item      TO r_accountant;
GRANT SELECT ON shop.v_monthly_sales TO r_accountant;

-- ② 建三个用户，分别授予角色，并设为登录后默认启用
CREATE USER 'boss'@'%'       IDENTIFIED BY 'Boss#2026';
CREATE USER 'clerk'@'%'      IDENTIFIED BY 'Clerk#2026';
CREATE USER 'accountant'@'%' IDENTIFIED BY 'Acct#2026';

GRANT r_boss       TO 'boss'@'%';
GRANT r_clerk      TO 'clerk'@'%';
GRANT r_accountant TO 'accountant'@'%';
SET DEFAULT ROLE ALL TO 'boss'@'%', 'clerk'@'%', 'accountant'@'%';

-- ③ 查看授权
SHOW GRANTS FOR 'clerk'@'%';
SHOW GRANTS FOR 'clerk'@'%' USING r_clerk;
