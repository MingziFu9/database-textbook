"""实验 12-1：手算并验证余弦相似度、欧氏距离和内积。运行：python lab12_1_similarity.py"""
import numpy as np

from teaching_vectors import PRODUCTS, QUERY_TEXT, QUERY_VEC

q = np.array(QUERY_VEC)
oats = np.array(PRODUCTS[1][3])        # 燕麦片 [0.9, 0.8, 0, 0]
chips = np.array(PRODUCTS[7][3])       # 薯片   [0, 0, 0.9, 0]

# ① 先手算（写在记录表上），再用 numpy 验证
print("① 查询向量", q, " 燕麦片", oats, " 薯片", chips)
dot = np.dot(q, oats)                                  # 内积：对应位置相乘再相加
norm_q, norm_o = np.linalg.norm(q), np.linalg.norm(oats)   # 长度：各分量平方和再开方
print(f"   内积 q·燕麦片 = {dot:.2f}")
print(f"   长度 |q| = {norm_q:.4f}，|燕麦片| = {norm_o:.4f}")
print(f"   余弦相似度 = {dot / (norm_q * norm_o):.4f}")
print(f"   欧氏距离   = {np.linalg.norm(q - oats):.4f}")
cos_chips = np.dot(q, chips) / (np.linalg.norm(q) * np.linalg.norm(chips))
print(f"   查询与薯片：余弦相似度 = {cos_chips:.4f}，欧氏距离 = {np.linalg.norm(q - chips):.4f}")


# ② 和所有商品比一遍，按余弦相似度从高到低排，取前 3 名（这就是“找最近的 K 个”）
def cosine(a, b):
    a, b = np.array(a), np.array(b)
    return float(np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b)))


scores = sorted(((cosine(QUERY_VEC, v), name, price) for _, name, price, v in PRODUCTS),
                reverse=True)
print(f"\n② 问题：{QUERY_TEXT}")
for rank, (s, name, price) in enumerate(scores, start=1):
    print(f"   {rank:2d}. {name:<14s} 相似度 {s:.4f}  售价 {price:.2f}")
