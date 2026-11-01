-- 实验 10-2：备份前、恢复后各运行一次，两次结果应当一样
SELECT 'category' AS 表名, COUNT(*) AS 行数 FROM shop.category
UNION ALL SELECT 'product',    COUNT(*) FROM shop.product
UNION ALL SELECT 'customer',   COUNT(*) FROM shop.customer
UNION ALL SELECT 'orders',     COUNT(*) FROM shop.orders
UNION ALL SELECT 'order_item', COUNT(*) FROM shop.order_item;
SELECT SUM(quantity * unit_price) AS 全部销售额 FROM shop.order_item;
