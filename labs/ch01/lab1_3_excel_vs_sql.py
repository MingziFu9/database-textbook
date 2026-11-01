"""实验 1-3 ☆：用 pandas 模拟“在 Excel 里做”，和 SQL 的答案对一对。
在 labs/ 目录下运行：python ch01/lab1_3_excel_vs_sql.py
"""
import pandas as pd

orders = pd.read_csv("data/csv/orders.csv")          # 订单表
items = pd.read_csv("data/csv/order_item.csv")       # 订单明细表
products = pd.read_csv("data/csv/product.csv")       # 商品表
categories = pd.read_csv("data/csv/category.csv")    # 类别表

# 问题 1：2025 年（已完成订单）一共卖了多少钱？
done = orders[(orders["status"] == "已完成") & (orders["order_time"].str[:4] == "2025")]
rows = items.merge(done, on="order_id")              # 相当于 Excel 里的 VLOOKUP
print("问题 1  2025 年销售额：", round((rows["quantity"] * rows["unit_price"]).sum(), 2))

# 问题 2：哪三个类别卖得最多（全部已完成订单）？
all_done = items.merge(orders[orders["status"] == "已完成"], on="order_id")
all_done = all_done.merge(products[["product_id", "category_id"]], on="product_id")
all_done = all_done.merge(categories.rename(columns={"name": "类别"}), on="category_id")
all_done["金额"] = all_done["quantity"] * all_done["unit_price"]
print("问题 2  销售额前三的类别：")
print(all_done.groupby("类别")["金额"].sum().round(2).sort_values(ascending=False).head(3).to_string())

# 问题 3：库存少于 10 件的商品
print("问题 3  库存少于 10 的商品：")
print(products[products["stock"] < 10][["name", "stock"]].sort_values("stock").to_string(index=False))
