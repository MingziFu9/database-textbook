-- 实验 6-2 半成品：“网上订货与积分”新增的 4 张表（建在实验 3-1 的 myshop 库里）
-- 找到标有 TODO 的地方补全，全部运行通过后再和 lab6_2_online_order_answer.sql 对照
USE myshop;
DROP TABLE IF EXISTS points_log, online_order_item, online_order, address;

-- 收货地址：顾客 1 : N 地址
CREATE TABLE address (
  address_id  INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  receiver    VARCHAR(20) NOT NULL,
  phone       CHAR(11) NOT NULL,
  detail      VARCHAR(100) NOT NULL,              -- 小区 + 楼栋 + 房号
  is_default  BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- 网上订单：顾客 1 : N 网上订单，地址 1 : N 网上订单，配送员（员工）1 : N 网上订单
CREATE TABLE online_order (
  online_order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id     INT NOT NULL,
  address_id      INT NOT NULL,
  courier_id      INT,                              -- 配送员，接单后才填
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  delivery_date   DATE NOT NULL,
  delivery_slot   ENUM('上午', '下午', '晚上') NOT NULL,
  points_used     INT NOT NULL DEFAULT 0 CHECK (points_used >= 0),
  status          ENUM('待配送', '配送中', '已送达', '已取消') NOT NULL DEFAULT '待配送',
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
  -- TODO 1：再加两个外键：address_id 参照 address，courier_id 参照 employee
);

-- 网上订单明细：网上订单 M : N 商品 → 中间表
CREATE TABLE online_order_item (
  -- TODO 2：写出 4 列：online_order_id、product_id、quantity（必须大于 0）、unit_price
  --         主键是哪两列的组合？两个外键分别参照哪张表？
);

-- 积分流水：会员 1 : N 流水；一条流水可能来自一张网上订单（也可能是活动赠送，所以外键可空）
CREATE TABLE points_log (
  log_id          INT PRIMARY KEY AUTO_INCREMENT,
  member_id       INT NOT NULL,
  change_points   INT NOT NULL,                     -- 正数是得积分，负数是用积分
  reason          VARCHAR(20) NOT NULL,
  -- TODO 3：加一列 online_order_id，它可以为空吗？为什么？
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (member_id) REFERENCES member(member_id)
  -- TODO 4：加上 online_order_id 的外键
);

-- 用一笔网上订单试一试：顾客 1（徐洋娟，金卡会员）在 6 月 30 日下单，送到默认地址，用了 100 积分
INSERT INTO address (customer_id, receiver, phone, detail, is_default)
VALUES (1, '徐洋娟', '10054751779', '滨江花园 2 栋 301', TRUE);
INSERT INTO online_order (customer_id, address_id, created_at, delivery_date, delivery_slot, points_used)
VALUES (1, LAST_INSERT_ID(), '2026-06-30 21:05:00', '2026-07-01', '上午', 100);
SET @oid = LAST_INSERT_ID();
INSERT INTO online_order_item VALUES (@oid, 1, 1, 39.90), (@oid, 8, 2, 26.90);
INSERT INTO points_log (member_id, change_points, reason, online_order_id, created_at)
SELECT member_id, -100, '下单抵扣', @oid, '2026-06-30 21:05:00' FROM member WHERE customer_id = 1;

SELECT o.online_order_id, c.name AS 顾客, a.detail AS 地址, o.delivery_date, o.delivery_slot,
       SUM(i.quantity * i.unit_price) AS 商品金额, o.points_used
FROM online_order o
JOIN customer c          ON c.customer_id = o.customer_id
JOIN address a           ON a.address_id = o.address_id
JOIN online_order_item i ON i.online_order_id = o.online_order_id
GROUP BY o.online_order_id;

SELECT * FROM points_log;
