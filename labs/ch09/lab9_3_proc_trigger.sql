-- 实验 9-3 存储过程“月度销售汇总”和改价日志触发器（在 txshop 里做）
-- 命令行 mysql 需要 DELIMITER；DBeaver 中选中整个 CREATE … END 再按 Ctrl+Enter 执行即可
USE txshop;

-- ① 月度汇总表，存储过程每次把某个月算好写进去
DROP TABLE IF EXISTS monthly_summary;
CREATE TABLE monthly_summary (
  month       CHAR(7) PRIMARY KEY,           -- 如 2026-06
  order_count INT NOT NULL,
  sales       DECIMAL(12,2) NOT NULL,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS sp_month_summary;
DELIMITER //
CREATE PROCEDURE sp_month_summary(IN p_month CHAR(7), OUT p_sales DECIMAL(12,2))
BEGIN
  DECLARE v_start DATE;
  SET v_start = STR_TO_DATE(CONCAT(p_month, '-01'), '%Y-%m-%d');

  SELECT IFNULL(SUM(oi.quantity * oi.unit_price), 0) INTO p_sales
  FROM orders o JOIN order_item oi ON oi.order_id = o.order_id
  WHERE o.status = '已完成'
    AND o.order_time >= v_start AND o.order_time < v_start + INTERVAL 1 MONTH;

  REPLACE INTO monthly_summary (month, order_count, sales)
  SELECT p_month, COUNT(*), p_sales
  FROM orders
  WHERE status = '已完成'
    AND order_time >= v_start AND order_time < v_start + INTERVAL 1 MONTH;
END //
DELIMITER ;

CALL sp_month_summary('2026-05', @s);
CALL sp_month_summary('2026-06', @s);
SELECT @s AS 六月销售额;
SELECT month, order_count, sales FROM monthly_summary ORDER BY month;

-- ② 改价日志：每次商品价格变化，自动记一笔
DROP TABLE IF EXISTS price_log;
CREATE TABLE price_log (
  log_id     INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  old_price  DECIMAL(8,2) NOT NULL,
  new_price  DECIMAL(8,2) NOT NULL,
  changed_by VARCHAR(50) NOT NULL,
  changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS trg_price_log;
DELIMITER //
CREATE TRIGGER trg_price_log
AFTER UPDATE ON product
FOR EACH ROW
BEGIN
  IF NEW.price <> OLD.price THEN
    INSERT INTO price_log (product_id, old_price, new_price, changed_by)
    VALUES (OLD.product_id, OLD.price, NEW.price, CURRENT_USER());
  END IF;
END //
DELIMITER ;

UPDATE product SET price = 42.00 WHERE product_id = 1;      -- 改价：会记日志
UPDATE product SET stock = stock + 10 WHERE product_id = 1;  -- 只改库存：不记
UPDATE product SET price = ROUND(price * 0.9, 1) WHERE category_id = 4;   -- 饮料九折：5 行都记
SELECT product_id, old_price, new_price, changed_by FROM price_log ORDER BY log_id;
