-- 实验 12-3：在 PostgreSQL + pgvector 里用 SQL 做相似度查询（在 shop 库里运行）
CREATE EXTENSION IF NOT EXISTS vector;               -- ① 启用 pgvector 扩展

DROP TABLE IF EXISTS product_vec;
CREATE TABLE product_vec (                           -- ② 向量就是表里的一列，类型 vector(维数)
  product_id INT PRIMARY KEY,
  name       VARCHAR(40),
  price      DECIMAL(8,2),
  embedding  vector(4)                               -- 教学向量：早餐、软糯、零食、日用
);
INSERT INTO product_vec VALUES
  (7,  '小米 1kg',         15.80, '[0.9, 1.0, 0, 0]'),
  (8,  '燕麦片 1kg',       26.90, '[0.9, 0.8, 0, 0]'),
  (10, '芝麻糊 600g',      18.80, '[0.7, 0.9, 0, 0]'),
  (12, '全麦面包 400g',    12.90, '[0.8, 0.6, 0.1, 0]'),
  (13, '鲜肉包 6 个',      15.00, '[0.8, 0.5, 0, 0]'),
  (25, '纯牛奶 250ml×16',  52.00, '[0.7, 0.4, 0, 0]'),
  (11, '速溶咖啡 40 条',   45.00, '[0.4, 0, 0.1, 0]'),
  (14, '原味薯片 104g',     8.90, '[0, 0, 0.9, 0]'),
  (17, '牛肉干 100g',      35.00, '[0, 0, 0.8, 0]'),
  (28, '儿童奶酪棒 20 支', 39.90, '[0.1, 0.7, 0.6, 0]'),
  (44, '洗衣液 3kg',       45.90, '[0, 0, 0, 1]');

-- ③ 相似度查询：<=> 是余弦距离，越小越相近；1 - 距离 = 余弦相似度
SELECT name, price,
       ROUND((embedding <=> '[0.9, 0.9, 0, 0]')::numeric, 4)     AS 余弦距离,
       ROUND((1 - (embedding <=> '[0.9, 0.9, 0, 0]'))::numeric, 4) AS 余弦相似度
FROM product_vec
ORDER BY embedding <=> '[0.9, 0.9, 0, 0]'
LIMIT 3;

-- ④ 向量条件和普通条件写在同一条 SQL 里：售价不超过 16 元
SELECT name, price, ROUND((embedding <=> '[0.9, 0.9, 0, 0]')::numeric, 4) AS 余弦距离
FROM product_vec
WHERE price <= 16
ORDER BY embedding <=> '[0.9, 0.9, 0, 0]'
LIMIT 3;

-- ⑤ 另外两种距离：<-> 欧氏距离，<#> 负内积
SELECT name,
       ROUND((embedding <-> '[0.9, 0.9, 0, 0]')::numeric, 4)  AS 欧氏距离,
       ROUND((-(embedding <#> '[0.9, 0.9, 0, 0]'))::numeric, 4) AS 内积
FROM product_vec ORDER BY embedding <-> '[0.9, 0.9, 0, 0]' LIMIT 3;

-- ⑥ 建 HNSW 索引（数据多时才有用），并查看执行计划
CREATE INDEX ON product_vec USING hnsw (embedding vector_cosine_ops);
SET enable_seqscan = off;                            -- 只有 11 行，强制让它用索引，看看计划长什么样
EXPLAIN SELECT name FROM product_vec ORDER BY embedding <=> '[0.9, 0.9, 0, 0]' LIMIT 3;
RESET enable_seqscan;
