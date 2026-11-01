"""实验 12-2 第二部分：用嵌入模型 bge-small-zh-v1.5 给小店 48 种商品建向量库，做语义搜索。

运行前：pip install chromadb sentence-transformers pymysql
第一次运行会从 Hugging Face 下载模型（约 100 MB）。下载慢可以先设置镜像：
    Windows 命令提示符：set HF_ENDPOINT=https://hf-mirror.com
也可以从魔搭社区（modelscope.cn）下载模型文件夹，把下面的 MODEL 改成文件夹路径。
运行：python lab12_2_chroma_bge.py
"""
import sys

import chromadb
import pymysql
from chromadb.utils import embedding_functions

MODEL = "BAAI/bge-small-zh-v1.5"            # 或本机文件夹路径，如 r"D:\models\bge-small-zh-v1.5"
DB = dict(host="127.0.0.1", port=3306, user="root", password="shop123",
          database="shop", charset="utf8mb4")   # 按你的环境修改


def load_products():
    """从 MySQL 读出商品：编号、名称、描述、售价、类别。"""
    conn = pymysql.connect(**DB)
    with conn.cursor() as cur:
        cur.execute("SELECT p.product_id, p.name, p.description, p.price, c.name "
                    "FROM product p JOIN category c ON p.category_id = c.category_id")
        rows = cur.fetchall()
    conn.close()
    return rows


def build_collection(embed_fn):
    client = chromadb.PersistentClient(path="./chroma_shop")       # 存在本目录，下次直接用
    try:
        client.delete_collection("products")                      # 重新运行时先删旧的
    except Exception:
        pass
    col = client.create_collection(name="products", embedding_function=embed_fn,
                                   configuration={"hnsw": {"space": "cosine"}})
    rows = load_products()
    col.add(ids=[str(r[0]) for r in rows],
            documents=[f"{r[1]}：{r[2]}" for r in rows],          # 名称 + 描述 一起向量化
            metadatas=[{"price": float(r[3]), "category": r[4]} for r in rows])
    return col


def search(col, question, k=3, max_price=None):
    where = {"price": {"$lte": max_price}} if max_price else None
    res = col.query(query_texts=[question], n_results=k, where=where)
    print(f"\n问题：{question}" + (f"（售价不超过 {max_price} 元）" if max_price else ""))
    for doc, dist in zip(res["documents"][0], res["distances"][0]):
        print(f"   余弦距离 {dist:.4f}  {doc}")


if __name__ == "__main__":
    embed_fn = embedding_functions.SentenceTransformerEmbeddingFunction(model_name=MODEL)
    col = build_collection(embed_fn)
    print("已入库商品：", col.count(), "，向量维数：", len(embed_fn(["测试"])[0]))
    questions = sys.argv[1:] or ["适合老人吃的软一点的早餐", "看球的时候吃点什么", "家里洗衣服用的"]
    for q in questions:
        search(col, q)
    search(col, "适合老人吃的软一点的早餐", max_price=16)
