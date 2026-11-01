-- 实验 3-3 ☆ 参考答案：会员积分流水表（先自己设计，再对照）
USE myshop;
CREATE TABLE points_log (
  log_id     INT PRIMARY KEY AUTO_INCREMENT,               -- 流水号，自动编号
  member_id  INT NOT NULL,                                 -- 哪位会员
  order_id   INT,                                          -- 因哪笔订单变动（手工调整时为空）
  change_pts INT NOT NULL CHECK (change_pts <> 0),         -- 变动积分：正数加分，负数扣分
  reason     ENUM('消费','兑换','调整','过期') NOT NULL,    -- 变动原因
  log_time   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- 变动时间，不填就取当前时间
  FOREIGN KEY (member_id) REFERENCES member(member_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
-- 测试：1 号会员因 2501 号订单得 35 分；又兑换礼品扣 100 分
INSERT INTO points_log (member_id, order_id, change_pts, reason, log_time) VALUES (1, 2501, 35, '消费', '2026-06-30 19:20:00');
INSERT INTO points_log (member_id, change_pts, reason, log_time) VALUES (1, -100, '兑换', '2026-06-30 19:25:00');
SELECT * FROM points_log;
-- 下面三条都应该被拒绝：不存在的会员、积分为 0、原因不在列表里
INSERT INTO points_log (member_id, change_pts, reason) VALUES (999, 10, '消费');
INSERT INTO points_log (member_id, change_pts, reason) VALUES (1, 0, '消费');
INSERT INTO points_log (member_id, change_pts, reason) VALUES (1, 10, '赠送');
