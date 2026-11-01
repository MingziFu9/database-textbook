-- 12.4 节演示：10 万条 128 维向量（模拟真实嵌入“成簇”的特点：500 个簇中心 + 随机扰动），逐个比较（精确）和 HNSW 索引（近似）的速度与召回率
-- 在 PostgreSQL 的 shop 库里运行；psql 中先输入 \timing on 显示耗时
SELECT setseed(0.42);
DROP TABLE IF EXISTS vec_bench;
DROP TABLE IF EXISTS vec_center;
CREATE TABLE vec_center AS                            -- 500 个簇中心
SELECT c, (SELECT array_agg(random())::vector(128) FROM generate_series(1, 128) WHERE c > 0) AS v
FROM generate_series(0, 499) AS c;
CREATE TABLE vec_bench (id INT PRIMARY KEY, v vector(128));
INSERT INTO vec_bench                                 -- 每条 = 某个簇中心 + 小的随机扰动
SELECT i, c.v + (SELECT array_agg((random() - 0.5) * 0.8)::vector(128)
                 FROM generate_series(1, 128) WHERE i > 0)
FROM generate_series(1, 100000) AS i
JOIN vec_center c ON c.c = i % 500;

DROP TABLE IF EXISTS vec_query;                       -- 准备 20 个查询向量
CREATE TABLE vec_query AS                            -- 查询向量也来自这些簇
SELECT q, c.v + (SELECT array_agg((random() - 0.5) * 0.8)::vector(128)
                 FROM generate_series(1, 128) WHERE q > 0) AS v
FROM generate_series(1, 20) AS q
JOIN vec_center c ON c.c = q * 17;

-- ① 精确查找：没有向量索引，每个查询都要和 10 万条逐个比较
DROP TABLE IF EXISTS exact_result;
CREATE TABLE exact_result AS
SELECT q.q, t.id
FROM vec_query q
CROSS JOIN LATERAL (SELECT id FROM vec_bench ORDER BY v <=> q.v LIMIT 10) t;

SET maintenance_work_mem = '256MB';            -- 建索引时多给点内存，建得快些
SET max_parallel_maintenance_workers = 0;       -- 不并行建（Docker 默认共享内存只有 64MB）
-- ② 建 HNSW 索引（m：每个点连几个邻居；ef_construction：建索引时找多少个候选）
CREATE INDEX vec_bench_hnsw ON vec_bench USING hnsw (v vector_cosine_ops)
  WITH (m = 16, ef_construction = 64);

-- ③ 近似查找：ef_search 越大，找得越仔细，越准也越慢；分别试 10、40、100
SET hnsw.ef_search = 10;
DROP TABLE IF EXISTS ann_result;
CREATE TABLE ann_result AS
SELECT q.q, t.id FROM vec_query q
CROSS JOIN LATERAL (SELECT id FROM vec_bench ORDER BY v <=> q.v LIMIT 10) t;
SELECT 10 AS ef_search, ROUND(COUNT(*)::numeric / 200 * 100, 1) AS 召回率百分比
FROM ann_result a JOIN exact_result e ON a.q = e.q AND a.id = e.id;

SET hnsw.ef_search = 40;
DROP TABLE IF EXISTS ann_result;
CREATE TABLE ann_result AS
SELECT q.q, t.id FROM vec_query q
CROSS JOIN LATERAL (SELECT id FROM vec_bench ORDER BY v <=> q.v LIMIT 10) t;
SELECT 40 AS ef_search, ROUND(COUNT(*)::numeric / 200 * 100, 1) AS 召回率百分比
FROM ann_result a JOIN exact_result e ON a.q = e.q AND a.id = e.id;

SET hnsw.ef_search = 100;
DROP TABLE IF EXISTS ann_result;
CREATE TABLE ann_result AS
SELECT q.q, t.id FROM vec_query q
CROSS JOIN LATERAL (SELECT id FROM vec_bench ORDER BY v <=> q.v LIMIT 10) t;
SELECT 100 AS ef_search, ROUND(COUNT(*)::numeric / 200 * 100, 1) AS 召回率百分比
FROM ann_result a JOIN exact_result e ON a.q = e.q AND a.id = e.id;
-- 20 个查询 × 前 10 名 = 200 条精确结果；召回率 = 近似结果中命中的条数 / 200
