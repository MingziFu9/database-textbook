-- 第 11 章：给小程序建一个专用账号（用 root 运行一次）
-- 程序只需要查询和录订单、扣库存，不需要删表、建表，更不需要 root
DROP USER IF EXISTS 'shopapp'@'%';
CREATE USER 'shopapp'@'%' IDENTIFIED BY 'App#2026';
GRANT SELECT ON shop.* TO 'shopapp'@'%';
GRANT INSERT ON shop.orders TO 'shopapp'@'%';
GRANT INSERT ON shop.order_item TO 'shopapp'@'%';
GRANT UPDATE (stock) ON shop.product TO 'shopapp'@'%';
CREATE TABLE IF NOT EXISTS shop.monthly_report (           -- 实验 11-2 用 pandas 写回的报表
  month VARCHAR(7) PRIMARY KEY, orders INT, sales DECIMAL(10,2), growth DECIMAL(6,1));
GRANT INSERT, DELETE, SELECT ON shop.monthly_report TO 'shopapp'@'%';
SHOW GRANTS FOR 'shopapp'@'%';
