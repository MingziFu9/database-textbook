-- 第 9 章正文中的例子（在 txshop 里运行；先运行 lab9_0_setup.sql 还原）
USE txshop;

-- 9.4.1 用户变量
SET @low = 10;
SELECT name, stock FROM product WHERE stock < @low;
SELECT COUNT(*) INTO @n FROM orders WHERE status = '已退款';
SELECT @n AS 退款单数;

-- 9.4.2 存储过程：查库存不足的商品（带输入参数）
DROP PROCEDURE IF EXISTS sp_low_stock;
DELIMITER //
CREATE PROCEDURE sp_low_stock(IN p_limit INT)
BEGIN
  SELECT product_id, name, stock
  FROM product
  WHERE stock < p_limit
  ORDER BY stock;
END //
DELIMITER ;
CALL sp_low_stock(10);

-- 9.4.3 带流程控制和输出参数：按积分算会员等级
DROP PROCEDURE IF EXISTS sp_level;
DELIMITER //
CREATE PROCEDURE sp_level(IN p_points INT, OUT p_level VARCHAR(10))
BEGIN
  IF p_points >= 1500 THEN
    SET p_level = '金卡';
  ELSEIF p_points >= 600 THEN
    SET p_level = '银卡';
  ELSE
    SET p_level = '普通';
  END IF;
END //
DELIMITER ;
CALL sp_level(800, @lv);
SELECT @lv AS 等级;

-- 9.4.4 循环：WHILE 算 1 到 100 的和
DROP PROCEDURE IF EXISTS sp_sum100;
DELIMITER //
CREATE PROCEDURE sp_sum100()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE s INT DEFAULT 0;
  WHILE i <= 100 DO
    SET s = s + i;
    SET i = i + 1;
  END WHILE;
  SELECT s AS 一到一百的和;
END //
DELIMITER ;
CALL sp_sum100();

-- 9.4.5 存储函数：计算订单金额
DROP FUNCTION IF EXISTS fn_order_amount;
DELIMITER //
CREATE FUNCTION fn_order_amount(p_order_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
  DECLARE v DECIMAL(10,2);
  SELECT SUM(quantity * unit_price) INTO v FROM order_item WHERE order_id = p_order_id;
  RETURN IFNULL(v, 0);
END //
DELIMITER ;
SELECT order_id, fn_order_amount(order_id) AS 金额 FROM orders WHERE order_id IN (2499, 2500, 2501);

-- 9.5 触发器：卖出商品时自动扣库存；库存不够就拒绝
DROP TRIGGER IF EXISTS trg_item_check;
DROP TRIGGER IF EXISTS trg_item_stock;
DELIMITER //
CREATE TRIGGER trg_item_check
BEFORE INSERT ON order_item
FOR EACH ROW
BEGIN
  IF (SELECT stock FROM product WHERE product_id = NEW.product_id) < NEW.quantity THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '库存不足，不能下单';
  END IF;
END //
CREATE TRIGGER trg_item_stock
AFTER INSERT ON order_item
FOR EACH ROW
BEGIN
  UPDATE product SET stock = stock - NEW.quantity WHERE product_id = NEW.product_id;
END //
DELIMITER ;
SHOW TRIGGERS;

INSERT INTO orders (customer_id, employee_id, order_time, pay_method) VALUES (2, 4, '2026-07-01 09:00:00', '现金');
SET @oid = LAST_INSERT_ID();
INSERT INTO order_item VALUES (@oid, 14, 3, 8.90);          -- 薯片 8 → 5
SELECT stock FROM product WHERE product_id = 14;
INSERT INTO order_item VALUES (@oid, 5, 1, 8.50);           -- 挂面库存 0：被拒绝
