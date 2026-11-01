-- 实验 3-1：建立自己的小店数据库 myshop（8 张表，结构与示例库 shop 相同）
DROP DATABASE IF EXISTS myshop;   -- 如果已经有 myshop，先删掉重建（注意：会删除里面的全部数据）
CREATE DATABASE myshop DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE myshop;

CREATE TABLE category (
  category_id INT PRIMARY KEY,
  name        VARCHAR(20) NOT NULL UNIQUE
);
CREATE TABLE supplier (
  supplier_id INT PRIMARY KEY,
  name        VARCHAR(40) NOT NULL,
  contact     VARCHAR(20),
  phone       CHAR(11),
  city        VARCHAR(20)
);
CREATE TABLE product (
  product_id  INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(40) NOT NULL,
  category_id INT NOT NULL,
  supplier_id INT,
  price       DECIMAL(8,2) NOT NULL CHECK (price > 0),
  cost        DECIMAL(8,2),
  stock       INT NOT NULL DEFAULT 0,
  unit        VARCHAR(10),
  description VARCHAR(200),
  shelf_date  DATE,
  FOREIGN KEY (category_id) REFERENCES category(category_id),
  FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);
CREATE TABLE employee (
  employee_id INT PRIMARY KEY,
  name        VARCHAR(20) NOT NULL,
  position    VARCHAR(20) NOT NULL,
  manager_id  INT,
  hire_date   DATE,
  salary      DECIMAL(8,2),
  FOREIGN KEY (manager_id) REFERENCES employee(employee_id)
);
CREATE TABLE customer (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(20) NOT NULL,
  gender      ENUM('男','女'),
  phone       CHAR(11) UNIQUE,
  district    VARCHAR(20),
  birth_year  SMALLINT,
  reg_date    DATE NOT NULL
);
CREATE TABLE member (
  member_id   INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL UNIQUE,
  level       VARCHAR(10) NOT NULL DEFAULT '普通',
  points      INT NOT NULL DEFAULT 0,
  join_date   DATE NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
CREATE TABLE orders (
  order_id    INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  employee_id INT NOT NULL,
  order_time  DATETIME NOT NULL,
  pay_method  VARCHAR(10),
  status      VARCHAR(10) NOT NULL DEFAULT '已完成',
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);
CREATE TABLE order_item (
  order_id    INT,
  product_id  INT,
  quantity    INT NOT NULL CHECK (quantity > 0),
  unit_price  DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES product(product_id)
);
