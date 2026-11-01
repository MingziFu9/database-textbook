"""实验 11-2：用窗口函数和 pandas 做小店月度销售分析。运行：python lab11_2_sales_analysis.py"""
import matplotlib
import matplotlib.pyplot as plt
import pandas as pd

from shopdb import get_engine

matplotlib.rcParams["font.sans-serif"] = ["Microsoft YaHei", "SimHei", "WenQuanYi Zen Hei"]  # 中文字体
matplotlib.rcParams["axes.unicode_minus"] = False
engine = get_engine()

# ① 2026 年上半年每月销售额、累计销售额、环比增长率
sql_month = """
WITH m AS (                                   -- 每月订单数、销售额（只算已完成的订单）
  SELECT DATE_FORMAT(o.order_time, '%%Y-%%m') AS month,
         COUNT(DISTINCT o.order_id) AS orders,
         SUM(i.quantity * i.unit_price) AS sales
  FROM orders o JOIN order_item i ON o.order_id = i.order_id
  WHERE o.status = '已完成'
    AND o.order_time >= '2025-12-01' AND o.order_time < '2026-07-01'
  GROUP BY month
), g AS (                                     -- 环比：和上个月比（所以要多取 2025 年 12 月）
  SELECT month, orders, sales,
         ROUND((sales - LAG(sales) OVER (ORDER BY month))
               / LAG(sales) OVER (ORDER BY month) * 100, 1) AS growth
  FROM m
)
SELECT month, orders, sales,
       SUM(sales) OVER (ORDER BY month) AS running_total,   -- 从 1 月起的累计销售额
       growth
FROM g WHERE month >= '2026-01' ORDER BY month
"""
df = pd.read_sql(sql_month, engine)
print("① 2026 年上半年月度销售")
print(df.to_string(index=False))

# ② 每个类别销售额前 2 名的商品（2026 年上半年）
sql_top = """
WITH s AS (
  SELECT c.name AS category, p.name AS product,
         SUM(i.quantity * i.unit_price) AS sales,
         ROW_NUMBER() OVER (PARTITION BY c.category_id
                            ORDER BY SUM(i.quantity * i.unit_price) DESC) AS rn
  FROM orders o
  JOIN order_item i ON o.order_id = i.order_id
  JOIN product p ON i.product_id = p.product_id
  JOIN category c ON p.category_id = c.category_id
  WHERE o.status = '已完成'
    AND o.order_time >= '2026-01-01' AND o.order_time < '2026-07-01'
  GROUP BY c.category_id, c.name, p.product_id, p.name
)
SELECT category, product, sales, rn FROM s WHERE rn <= 2 ORDER BY sales DESC
"""
top = pd.read_sql(sql_top, engine)
print("\n② 各类别销售额前 2 名")
print(top.to_string(index=False))

# ③ pandas 再加工：按类别把前 2 名的销售额加起来
print("\n③ 前 2 名合计最高的 3 个类别（pandas 分组求和）")
print(top.groupby("category")["sales"].sum().sort_values(ascending=False).head(3))

# ④ 画图：月度销售额柱状图 + 累计销售额折线
ax = df.plot(x="month", y="sales", kind="bar", legend=False, figsize=(7, 4), color="#4C78A8")
ax.set_xlabel("月份")
ax.set_ylabel("销售额（元）")
ax.set_title("社区小店 2026 年上半年月度销售额")
for x, y in enumerate(df["sales"]):
    ax.text(x, y + 150, f"{y:,.0f}", ha="center", fontsize=9)
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig("monthly_sales.png", dpi=150)
print("\n④ 图已保存为 monthly_sales.png")

# ⑤ 把分析结果写回数据库，供会计查看
with engine.begin() as conn:                       # begin()：成功自动提交，出错自动回滚
    conn.exec_driver_sql("DELETE FROM monthly_report")
    df[["month", "orders", "sales", "growth"]].to_sql("monthly_report", conn,
                                                       if_exists="append", index=False)
print(pd.read_sql("SELECT * FROM monthly_report ORDER BY month", engine).to_string(index=False))
