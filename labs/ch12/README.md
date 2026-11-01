# 第 12 章 向量数据库原理：实验代码

| 文件 | 用途 | 编者实测 |
|---|---|---|
| teaching_vectors.py | 11 种商品的 4 维教学向量（手工打分） | — |
| lab12_1_similarity.py | 实验 12-1：手算并验证余弦相似度、欧氏距离、内积 | 已实测 |
| lab12_2_chroma_basic.py | 实验 12-2 第一部分：用教学向量练 Chroma 的增删改查和元数据过滤 | 已实测（chromadb 1.5.9） |
| lab12_2_chroma_bge.py | 实验 12-2 第二部分：bge-small-zh-v1.5 + Chroma 做 48 种商品语义搜索 | 待实测（编者环境下载不到模型，只验证过程序流程） |
| lab12_3_pgvector.sql | 实验 12-3：PostgreSQL + pgvector 相似度查询 | 已实测（pgvector 0.8.7） |
| demo12_hnsw_bench.sql | 12.4.3 演示：10 万条向量精确查找与 HNSW 的速度、召回率 | 已实测 |

安装：`pip install numpy chromadb`；第二部分另需 `pip install sentence-transformers pymysql`，并能访问 Hugging Face（可设 `HF_ENDPOINT=https://hf-mirror.com`）或从魔搭社区下载模型。
