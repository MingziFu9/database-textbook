"""实验 11-3：小店管理助手的“业务层”，界面只调用这里的函数，不直接写 SQL。"""
import pandas as pd

from shopdb import get_connection, get_engine


def search_products(keyword):
    """按名称关键字查商品，返回 DataFrame。"""
    sql = ("SELECT p.product_id AS 编号, p.name AS 商品, c.name AS 类别, "
           "p.price AS 售价, p.stock AS 库存 "
           "FROM product p JOIN category c ON p.category_id = c.category_id "
           "WHERE p.name LIKE %(kw)s ORDER BY p.product_id")
    return pd.read_sql(sql, get_engine(), params={"kw": f"%{keyword}%"})


def low_stock(limit=10):
    sql = "SELECT name AS 商品, stock AS 库存 FROM product WHERE stock < %(n)s ORDER BY stock"
    return pd.read_sql(sql, get_engine(), params={"n": limit})


def place_order(customer_id, employee_id, items, pay_method="微信"):
    """事务下单（同实验 11-1）。items: [(商品编号, 数量), ...]，返回新订单号。"""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO orders (customer_id, employee_id, order_time, pay_method) "
                        "VALUES (%s, %s, NOW(), %s)", (customer_id, employee_id, pay_method))
            order_id = cur.lastrowid
            for product_id, qty in items:
                cur.execute("SELECT name, price, stock FROM product "
                            "WHERE product_id = %s FOR UPDATE", (product_id,))
                row = cur.fetchone()
                if row is None:
                    raise ValueError(f"没有编号为 {product_id} 的商品")
                name, price, stock = row
                if stock < qty:
                    raise ValueError(f"{name} 库存只有 {stock}，不够 {qty}")
                cur.execute("INSERT INTO order_item VALUES (%s, %s, %s, %s)",
                            (order_id, product_id, qty, price))
                cur.execute("UPDATE product SET stock = stock - %s WHERE product_id = %s",
                            (qty, product_id))
        conn.commit()
        return order_id
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def monthly_sales():
    """读取第 8 章建的月度销售视图。"""
    return pd.read_sql("SELECT month AS 月份, orders AS 订单数, sales AS 销售额 "
                       "FROM v_monthly_sales ORDER BY month", get_engine())
