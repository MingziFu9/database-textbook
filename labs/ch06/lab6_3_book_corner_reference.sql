-- 实验 6-3 参考设计：“社区图书角”（一种可行的方案，不是唯一答案）
DROP DATABASE IF EXISTS bookcorner;
CREATE DATABASE bookcorner DEFAULT CHARACTER SET utf8mb4;
USE bookcorner;

-- 读者（小区居民）
CREATE TABLE reader (
  reader_id INT PRIMARY KEY AUTO_INCREMENT,
  name      VARCHAR(20) NOT NULL,
  phone     CHAR(11) NOT NULL UNIQUE,
  building  VARCHAR(10) NOT NULL,                  -- 住在几栋，方便上门催还
  join_date DATE NOT NULL
);

-- 图书分类
CREATE TABLE book_category (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(20) NOT NULL UNIQUE
);

-- 书目：同一种书（同一个 ISBN）只记一行
CREATE TABLE book (
  isbn        CHAR(13) PRIMARY KEY,
  title       VARCHAR(100) NOT NULL,
  author      VARCHAR(50),
  category_id INT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES book_category(category_id)
);

-- 实体书：同一种书可能有好几本（有人捐了两本），每一本贴一个编号
CREATE TABLE book_copy (
  copy_id    INT PRIMARY KEY AUTO_INCREMENT,
  isbn       CHAR(13) NOT NULL,
  donor_id   INT,                                  -- 谁捐的，可以为空（图书角自己买的）
  shelf_date DATE NOT NULL,
  FOREIGN KEY (isbn)     REFERENCES book(isbn),
  FOREIGN KEY (donor_id) REFERENCES reader(reader_id)
);

-- 借阅：读者 M : N 实体书（一个人借很多次，一本书被很多人借过）→ 借阅记录表
CREATE TABLE borrow (
  borrow_id   INT PRIMARY KEY AUTO_INCREMENT,
  copy_id     INT NOT NULL,
  reader_id   INT NOT NULL,
  borrow_date DATE NOT NULL,
  due_date    DATE NOT NULL,
  return_date DATE,                                -- 还没还时为空
  CHECK (due_date >= borrow_date),
  FOREIGN KEY (copy_id)   REFERENCES book_copy(copy_id),
  FOREIGN KEY (reader_id) REFERENCES reader(reader_id)
);

INSERT INTO reader (name, phone, building, join_date) VALUES
  ('陈阿姨', '10000000101', '1 栋', '2026-03-01'), ('小周', '10000000102', '4 栋', '2026-03-05'), ('马老师', '10000000103', '2 栋', '2026-04-10');
INSERT INTO book_category (name) VALUES ('少儿'), ('文学'), ('生活');
INSERT INTO book VALUES ('9787000000011', '小猪佩奇绘本', '编者甲', 1), ('9787000000028', '活着', '余华', 2), ('9787000000035', '家常菜 300 例', '编者乙', 3);
INSERT INTO book_copy (isbn, donor_id, shelf_date) VALUES
  ('9787000000011', 1, '2026-03-02'), ('9787000000011', 3, '2026-04-11'), ('9787000000028', NULL, '2026-03-02'), ('9787000000035', 2, '2026-03-06');
INSERT INTO borrow (copy_id, reader_id, borrow_date, due_date, return_date) VALUES
  (1, 2, '2026-06-01', '2026-06-15', '2026-06-12'),
  (3, 1, '2026-06-10', '2026-06-24', NULL),
  (2, 2, '2026-06-20', '2026-07-04', NULL);

-- 到 2026-06-30 还没还、而且已经过期的书
SELECT r.name AS 读者, r.building AS 楼栋, b.title AS 书名, br.due_date AS 应还日期,
       DATEDIFF('2026-06-30', br.due_date) AS 过期天数
FROM borrow br
JOIN reader r     ON r.reader_id = br.reader_id
JOIN book_copy bc ON bc.copy_id = br.copy_id
JOIN book b       ON b.isbn = bc.isbn
WHERE br.return_date IS NULL AND br.due_date < '2026-06-30';

-- 每种书有几本、现在有几本在架上
SELECT b.title AS 书名, COUNT(bc.copy_id) AS 总本数,
       COUNT(bc.copy_id) - COUNT(br.borrow_id) AS 在架
FROM book b
JOIN book_copy bc   ON bc.isbn = b.isbn
LEFT JOIN borrow br ON br.copy_id = bc.copy_id AND br.return_date IS NULL
GROUP BY b.isbn, b.title;
