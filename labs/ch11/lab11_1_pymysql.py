"""实验 11-1：用 PyMySQL 完成查询、插入和事务下单。在 labs/ch11 目录下运行：python lab11_1_pymysql.py"""
import pymysql

from shopdb import get_connection

# ① 查询：连接 → 游标 → 执行 → 取结果 → 关闭
conn = get_connection()
cur = conn.cursor()
cur.execute("SELECT COUNT(*) FROM product")
print("① 商品总数：", cur.fetchone()[0])

cur.execute("SELECT name, price, stock FROM product WHERE stock < %s ORDER BY stock", (10,))
for name, price, stock in cur.fetchall():
    print(f"   库存不足：{name}  {price} 元  剩 {stock}")
cur.close()
conn.close()

# ② 用 with 自动关闭；DictCursor 让每一行变成字典
with get_connection(dict_rows=True) as conn:
    with conn.cursor() as cur:
        cur.execute("SELECT product_id, name, price FROM product WHERE name LIKE %s", ("%牛奶%",))
        rows = cur.fetchall()
print("② 名字里有“牛奶”的商品：", rows)


# ③ 事务下单：写订单、写明细、扣库存，要么全做，要么全不做
def place_order(customer_id, employee_id, items):
    """items 是 [(商品编号, 数量), ...]，成功返回新订单号，失败抛出异常。"""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO orders (customer_id, employee_id, order_time, pay_method) "
                        "VALUES (%s, %s, NOW(), %s)", (customer_id, employee_id, "微信"))
            order_id = cur.lastrowid                       # 新订单号
            for product_id, qty in items:
                cur.execute("SELECT price, stock FROM product WHERE product_id = %s FOR UPDATE",
                            (product_id,))
                price, stock = cur.fetchone()
                if stock < qty:
                    raise ValueError(f"商品 {product_id} 库存只有 {stock}，不够 {qty}")
                cur.execute("INSERT INTO order_item VALUES (%s, %s, %s, %s)",
                            (order_id, product_id, qty, price))
                cur.execute("UPDATE product SET stock = stock - %s WHERE product_id = %s",
                            (qty, product_id))
        conn.commit()                                      # 全部成功才提交
        return order_id
    except Exception:
        conn.rollback()                                    # 任何一步出错都回滚
        raise
    finally:
        conn.close()


def stock_of(pid):
    with get_connection() as conn, conn.cursor() as cur:
        cur.execute("SELECT stock FROM product WHERE product_id = %s", (pid,))
        return cur.fetchone()[0]


print("③ 下单前库存：燕麦片", stock_of(8), "，挂面", stock_of(5))
new_id = place_order(1, 3, [(8, 2)])
print("   下单成功，订单号", new_id, "，燕麦片库存", stock_of(8))
try:
    place_order(1, 3, [(8, 1), (5, 1)])                    # 挂面库存是 0
except ValueError as e:
    print("   下单失败：", e)
print("   回滚后库存：燕麦片", stock_of(8), "，挂面", stock_of(5))
