-- 实验 4-2 按月、按商品、按类别统计（示例库 shop）
USE shop;

-- 1. 每月订单数和退款单数
SELECT DATE_FORMAT(order_time, '%Y-%m') AS 月份,
       COUNT(*) AS 订单数,
       SUM(status = '已退款') AS 退款单数
FROM orders
GROUP BY 月份
ORDER BY 月份;

-- 2. 一天里哪个钟点最忙？
SELECT HOUR(order_time) AS 钟点, COUNT(*) AS 订单数
FROM orders
GROUP BY 钟点
ORDER BY 钟点;

-- 3. 一周里哪天最忙？（DAYOFWEEK：1 = 星期日，2 = 星期一……7 = 星期六）
SELECT DAYOFWEEK(order_time) AS 星期, COUNT(*) AS 订单数
FROM orders
GROUP BY 星期
ORDER BY 星期;

-- 4. 销售额前 10 的商品（按订单明细统计，含已退款订单）
SELECT product_id,
       SUM(quantity) AS 销量,
       SUM(quantity * unit_price) AS 销售额
FROM order_item
GROUP BY product_id
ORDER BY 销售额 DESC
LIMIT 10;

-- 5. 各类别的商品数、平均毛利率、库存金额（按进价算）
SELECT category_id,
       COUNT(*) AS 商品数,
       ROUND(AVG((price - cost) / price) * 100, 1) AS 平均毛利率,
       SUM(cost * stock) AS 库存金额
FROM product
GROUP BY category_id
ORDER BY 库存金额 DESC;
