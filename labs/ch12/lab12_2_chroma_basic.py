"""实验 12-2 第一部分：用教学向量熟悉 Chroma 的基本操作。运行：python lab12_2_chroma_basic.py"""
import chromadb

from teaching_vectors import PRODUCTS, QUERY_TEXT, QUERY_VEC

client = chromadb.Client()                                    # 内存中的向量库，程序结束就消失
col = client.create_collection(name="shop_demo",              # ① 建集合，相当于建表
                               configuration={"hnsw": {"space": "cosine"}})  # 用余弦距离

col.add(                                                      # ② 插入：编号、向量、文本、元数据
    ids=[str(pid) for pid, _, _, _ in PRODUCTS],
    embeddings=[vec for _, _, _, vec in PRODUCTS],
    documents=[name for _, name, _, _ in PRODUCTS],
    metadatas=[{"price": price} for _, _, price, _ in PRODUCTS],
)
print("① 集合中的向量条数：", col.count())

res = col.query(query_embeddings=[QUERY_VEC], n_results=3)    # ③ 相似度查询：最近的 3 个
print(f"② 问题：{QUERY_TEXT}，最相近的 3 个：")
for doc, dist in zip(res["documents"][0], res["distances"][0]):
    print(f"   {doc:<14s} 余弦距离 {dist:.4f}")

res = col.query(query_embeddings=[QUERY_VEC], n_results=3,    # ④ 加元数据过滤：售价不超过 16 元
                where={"price": {"$lte": 16}})
print("③ 加上“售价不超过 16 元”：")
for doc, meta, dist in zip(res["documents"][0], res["metadatas"][0], res["distances"][0]):
    print(f"   {doc:<14s} 售价 {meta['price']:.2f}  余弦距离 {dist:.4f}")

col.update(ids=["8"], metadatas=[{"price": 23.90}])           # ⑤ 更新：燕麦片降价
col.delete(ids=["44"])                                        # ⑥ 删除：洗衣液下架
print("④ 更新、删除后：燕麦片", col.get(ids=["8"])["metadatas"][0], "，条数", col.count())
