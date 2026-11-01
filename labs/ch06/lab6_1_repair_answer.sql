-- 实验 6-1 参考答案：“小区物业报修”E-R 图转成的建表脚本
-- 先自己写出关系模式，再运行本脚本核对
DROP DATABASE IF EXISTS repair;
CREATE DATABASE repair DEFAULT CHARACTER SET utf8mb4;
USE repair;

-- 实体“业主”
CREATE TABLE owner (
  owner_id INT PRIMARY KEY AUTO_INCREMENT,
  name     VARCHAR(20) NOT NULL,
  phone    CHAR(11) NOT NULL UNIQUE
);

-- 实体“房屋”：楼栋 + 房号唯一
CREATE TABLE house (
  house_id INT PRIMARY KEY AUTO_INCREMENT,
  building VARCHAR(10) NOT NULL,
  room     VARCHAR(10) NOT NULL,
  area     DECIMAL(6,2),
  UNIQUE (building, room)
);

-- 联系“拥有”（业主 M : N 房屋）→ 中间表，主键是两个外键的组合
CREATE TABLE owner_house (
  owner_id INT,
  house_id INT,
  share    DECIMAL(5,2) DEFAULT 100.00,   -- 联系自己的属性：产权份额（%）
  PRIMARY KEY (owner_id, house_id),
  FOREIGN KEY (owner_id) REFERENCES owner(owner_id),
  FOREIGN KEY (house_id) REFERENCES house(house_id)
);

-- 实体“维修工”
CREATE TABLE worker (
  worker_id INT PRIMARY KEY AUTO_INCREMENT,
  name      VARCHAR(20) NOT NULL,
  skill     VARCHAR(20) NOT NULL          -- 水电、门窗、管道……
);

-- 实体“报修单”：房屋 1 : N 报修单，维修工 1 : N 报修单 → 在“多”的一方加外键
CREATE TABLE repair_order (
  repair_id   INT PRIMARY KEY AUTO_INCREMENT,
  house_id    INT NOT NULL,
  worker_id   INT,                       -- 刚报修时还没派人，可以为空
  report_time DATETIME NOT NULL,
  problem     VARCHAR(200) NOT NULL,
  status      ENUM('待派单', '维修中', '已完成') NOT NULL DEFAULT '待派单',
  FOREIGN KEY (house_id)  REFERENCES house(house_id),
  FOREIGN KEY (worker_id) REFERENCES worker(worker_id)
);

-- 试着放几行数据
INSERT INTO owner (name, phone) VALUES ('林海', '10000000001'), ('苏晴', '10000000002'), ('周敏', '10000000003');
INSERT INTO house (building, room, area) VALUES ('3 栋', '501', 89.50), ('3 栋', '502', 89.50), ('5 栋', '1201', 120.00);
INSERT INTO owner_house VALUES (1, 1, 50), (2, 1, 50), (1, 3, 100), (3, 2, 100);
INSERT INTO worker (name, skill) VALUES ('黄师傅', '水电'), ('陈师傅', '门窗');
INSERT INTO repair_order (house_id, worker_id, report_time, problem, status) VALUES
  (1, 1, '2026-06-02 09:10:00', '厨房水龙头漏水', '已完成'),
  (3, 2, '2026-06-05 14:30:00', '阳台推拉门卡住', '维修中'),
  (1, NULL, '2026-06-06 08:00:00', '卫生间灯不亮', '待派单');

SHOW TABLES;

-- 核对：每张报修单是哪套房、业主是谁、谁在修
SELECT r.repair_id, CONCAT(h.building, ' ', h.room) AS 房屋, o.name AS 业主,
       r.problem AS 问题, IFNULL(w.name, '未派单') AS 维修工, r.status
FROM repair_order r
JOIN house h        ON h.house_id = r.house_id
JOIN owner_house oh ON oh.house_id = h.house_id
JOIN owner o        ON o.owner_id = oh.owner_id
LEFT JOIN worker w  ON w.worker_id = r.worker_id
ORDER BY r.repair_id, o.owner_id;
