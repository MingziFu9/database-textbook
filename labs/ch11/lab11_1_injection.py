"""实验 11-1 第 4 步：拼接字符串和参数化查询的对比。"""
from shopdb import get_connection

inputs = ["10054751779", "' OR '1'='1"]                     # 正常输入、注入输入

with get_connection() as conn, conn.cursor() as cur:
    for text in inputs:
        # ✗ 危险写法：把输入直接拼进 SQL
        sql = "SELECT customer_id, name FROM customer WHERE phone = '" + text + "'"
        cur.execute(sql)
        print("拼接写法  输入", repr(text), "→ 查到", len(cur.fetchall()), "行")
        print("          实际执行的 SQL：", sql)
        # ✓ 安全写法：用 %s 占位，输入作为参数单独传
        safe_sql = "SELECT customer_id, name FROM customer WHERE phone = %s"
        cur.execute(safe_sql, (text,))
        print("参数化写法 输入", repr(text), "→ 查到", len(cur.fetchall()), "行")
        print("          实际执行的 SQL：", cur.mogrify(safe_sql, (text,)))
