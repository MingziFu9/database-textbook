---
title: 第 11 章 用 Python 开发数据库应用
description: 程序访问数据库的五个步骤，用 PyMySQL 查询、插入和在程序里使用事务；参数化查询防 SQL 注入，连接配置不写进代码；pandas 读写数据库；窗口函数 ROW_NUMBER、RANK、SUM() OVER、LAG 与小店月度销售分析；用 Streamlit 做一个“小店管理助手”
---

# 第 11 章 用 Python 开发数据库应用

!!! abstract "本章学时"
    理论 5 学时 · 实验 2 学时 · 线下研讨 1 学时（本章共 3 个实验，教师可任选）

## 学习目标

学完本章，你应该能够：

1. **说出**程序访问数据库的五个步骤，以及驱动、连接、游标各自的作用（记忆）；
2. **解释**拼接字符串为什么会造成 SQL 注入，参数化查询为什么能防住它（理解）；
3. **使用** PyMySQL 完成查询、插入，并在程序里用事务完成下单（应用）；
4. **使用**窗口函数完成排名、累计和环比计算，并用 pandas 读取结果、画图（应用）；
5. **分析**一个小应用应当怎样分层：界面、业务函数、数据库各管什么（分析）。

!!! info "先修要求"
    学习本章前，你需要：

    - 会写多表查询、分组统计和公用表表达式 WITH（[第 4、5 章](../05-multi-table-query/index.md)）；
    - 理解事务的提交和回滚（[9.1](../09-transaction/index.md#91)），了解 SQL 注入的原理（[10.6.1](../10-administration/index.md#1061-sql)）；
    - 会写 Python 的函数、循环、字典，会用 pip 安装第三方库（《Python 编程》第 1 学期的内容）。

??? abstract "本章概念清单（7 个，点击查看定义和例子）"
    1. [数据库驱动](../../appendix/glossary.md#g-数据库驱动)
    2. [数据库连接](../../appendix/glossary.md#g-数据库连接)
    3. [游标](../../appendix/glossary.md#g-游标)
    4. [参数化查询](../../appendix/glossary.md#g-参数化查询)
    5. [窗口函数](../../appendix/glossary.md#g-窗口函数)
    6. [数据挖掘](../../appendix/glossary.md#g-数据挖掘)
    7. [ORM](../../appendix/glossary.md#g-ORM)

## 情景导入

小店的数据库建好了，权限分好了，备份也做了。可老板还是不满意：“我又不会写 SQL，每次想看看哪些商品快卖完了，都得打电话问你。能不能做个小程序，我点一下按钮就能看？”

收银员小周也有意见：“在 DBeaver 里录订单要先插订单、再插明细、再改库存，一不小心就漏一步。”

表哥说：“这正是程序该干的活。数据库负责**存数据、保证数据对**；程序负责**和人打交道**：给老板一个按钮，给收银员一个表单。程序在背后替人写 SQL、管事务。”

本章就用第 1 学期《Python 编程》学过的 Python，给小店做一个“小店管理助手”：能查商品、录订单、看报表。顺带用一种新的 SQL 写法，窗口函数，做一份月度销售分析。

!!! tip "本章用到的 Python 库"
    在命令提示符里安装（清华镜像更快）：

    ```bash
    pip install pymysql sqlalchemy pandas matplotlib streamlit cryptography -i https://pypi.tuna.tsinghua.edu.cn/simple
    ```

    编者使用 Python 3.13、PyMySQL 1.2.3、SQLAlchemy 2.1.6、pandas 3.1.0、matplotlib 3.11.2、Streamlit 1.66.1。cryptography 是 MySQL 8 默认口令验证方式需要的。

## 11.1 程序怎样访问数据库

### 11.1.1 驱动、连接与游标

Python 本身不会说 MySQL 的“话”，需要一个翻译，这就是[**数据库驱动**](../../appendix/glossary.md#g-数据库驱动 "让程序能够与某种数据库通信的软件库，例如 Python 访问 MySQL 用 PyMySQL，访问 PostgreSQL 用 psycopg2"){ .term }。Python 访问 MySQL 最常用的驱动是 **PyMySQL**，访问 PostgreSQL 用 **psycopg2**。Python 为数据库驱动定了统一的接口规范（PEP 249）<sup class="cite">[[1]](#ref11-1)</sup>，所以换一种数据库，写法几乎一样。

程序访问数据库总是五步：

```mermaid
flowchart LR
  A["① 连接<br/>connect"] --> B["② 游标<br/>cursor"]
  B --> C["③ 执行<br/>execute"]
  C --> D["④ 取结果<br/>fetchone / fetchall"]
  D --> E["⑤ 关闭<br/>close"]
```

- [**数据库连接**](../../appendix/glossary.md#g-数据库连接 "程序与数据库服务器之间建立的一条通信通道，建立时要提供主机、端口、用户名、口令和数据库名；事务也在连接上提交或回滚"){ .term }：程序和数据库服务器之间的一条“电话线”。打通时要报上主机、端口、用户名、口令、数据库名，就像在 DBeaver 里新建连接一样。事务的提交、回滚也是在连接上做的；
- [**游标**](../../appendix/glossary.md#g-游标 "在数据库连接上执行 SQL 并逐行读取结果的对象，常用方法有 execute、fetchone、fetchall"){ .term }：在连接上执行 SQL、读取结果的工具。可以把它想成 DBeaver 里的一个 SQL 编辑窗口：`execute()` 是点“运行”，`fetchone()` 取一行结果，`fetchall()` 取全部结果。

### 11.1.2 第一个程序：查商品

本章所有代码在配套资源 `labs/ch11/` 目录里，运行前先用 root 执行一次 `lab11_0_setup.sql`，为程序建一个专用账号 shopapp（按第 10 章的最小权限原则，程序不用 root）。

```python
import pymysql

conn = pymysql.connect(host="127.0.0.1", port=3306, user="shopapp",
                       password="App#2026", database="shop", charset="utf8mb4")  # ① 连接
cur = conn.cursor()                                        # ② 游标
cur.execute("SELECT COUNT(*) FROM product")                # ③ 执行
print("商品总数：", cur.fetchone()[0])                      # ④ 取结果：一行，取第 0 列
cur.close()                                                # ⑤ 关闭
conn.close()
```

运行结果：`商品总数： 48`。

几点说明：

- `charset="utf8mb4"` 不能少，否则中文会变成问号；
- `fetchone()` 返回一行，是一个元组（tuple，元组的写法见《Python 编程》），`[0]` 取第一列；`fetchall()` 返回所有行，每行一个元组；
- 数据库里的 DECIMAL 类型，到了 Python 里是 `Decimal` 对象，例如 `Decimal('52.00')`，可以直接参加加减乘除，比浮点数算钱更准确。

### 11.1.3 用 with 自动关闭，用字典取列

忘了 `close()`，连接会一直占着，数据库的连接数（第 10 章的 max_connections）早晚会被占满。用 `with` 语句，代码块结束时会自动关闭（with 的用法见《Python 编程》的文件读写一章）：

```python
from shopdb import get_connection              # 自己写的小工具，见 11.3.1

with get_connection(dict_rows=True) as conn:   # 代码块结束自动关闭连接
    with conn.cursor() as cur:
        cur.execute("SELECT product_id, name, price FROM product WHERE name LIKE %s",
                    ("%牛奶%",))
        rows = cur.fetchall()
print(rows)
```

```text
[{'product_id': 25, 'name': '纯牛奶 250ml×16', 'price': Decimal('52.00')},
 {'product_id': 26, 'name': '低脂牛奶 1L', 'price': Decimal('15.50')}]
```

`dict_rows=True` 让程序使用 PyMySQL 的 DictCursor，每一行变成一个字典，可以用 `row["name"]` 按列名取值，比 `row[1]` 清楚。

注意 SQL 里的 `%s` 和后面的 `("%牛奶%",)`：这是下一节要讲的参数化查询。`("%牛奶%",)` 是只有一个元素的元组，**逗号不能少**。

## 11.2 参数化查询：堵住 SQL 注入

### 11.2.1 两种写法的对比

第 10 章讲过 SQL 注入：程序把用户输入直接拼进 SQL 字符串，攻击者输入 `' OR '1'='1` 就能查出全部顾客。现在用 Python 实际试一下（`lab11_1_injection.py`）：

```python
text = "' OR '1'='1"                                         # 攻击者的输入

# ✗ 危险写法：把输入直接拼进 SQL
sql = "SELECT customer_id, name FROM customer WHERE phone = '" + text + "'"
cur.execute(sql)

# ✓ 安全写法：SQL 里用 %s 占位，输入作为参数单独传给 execute
cur.execute("SELECT customer_id, name FROM customer WHERE phone = %s", (text,))
```

编者的运行结果：

```text
拼接写法  输入 '10054751779' → 查到 1 行
          实际执行的 SQL： SELECT customer_id, name FROM customer WHERE phone = '10054751779'
参数化写法 输入 '10054751779' → 查到 1 行
拼接写法  输入 "' OR '1'='1" → 查到 200 行
          实际执行的 SQL： SELECT customer_id, name FROM customer WHERE phone = '' OR '1'='1'
参数化写法 输入 "' OR '1'='1" → 查到 0 行
          实际执行的 SQL： SELECT customer_id, name FROM customer WHERE phone = '\' OR \'1\'=\'1'
```

正常输入时，两种写法结果一样；遇到注入串，拼接写法查出了全部 200 位顾客，参数化写法一行也没查到。看最后一行就明白了：PyMySQL 把输入里的单引号都**转义**成了 `\'`，整个输入变成了一个普通的字符串值，数据库只会去找“手机号恰好等于 `' OR '1'='1` 的顾客”，当然找不到。

这种 SQL 里用占位符、值单独传入的写法叫[**参数化查询**](../../appendix/glossary.md#g-参数化查询 "SQL 语句中用占位符代替具体值，执行时把值作为参数单独传给数据库驱动，值只会被当作数据，不会被当作 SQL 代码执行；是防止 SQL 注入的首要方法"){ .term }，它是防止 SQL 注入的首要办法<sup class="cite">[[2]](#ref11-2)</sup>。

<iframe class="sim-frame" src="../../sims/sql-injection/main.html" height="600" loading="lazy" title="SQL 注入演示"></iframe>
动画：SQL 注入演示。在“会员登录”框里输入手机号，或者输入几种常见的注入串，左边看拼接写法生成的 SQL 和查到的结果，右边看参数化写法。[全屏打开](../../sims/sql-injection/main.html){ target=_blank }
{ .sim-caption }

### 11.2.2 参数化查询的写法规则

| 规则 | 正确 | 错误 |
|---|---|---|
| 占位符一律写 `%s`，不管是数字、字符串还是日期 | `WHERE price < %s` | `WHERE price < %d` |
| 占位符外面**不加引号**，驱动会自动加 | `WHERE name = %s` | `WHERE name = '%s'` |
| 参数放在元组或列表里，作为 execute 的第二个参数 | `cur.execute(sql, (8,))` | `cur.execute(sql % (8,))` |
| LIKE 的通配符写在参数里 | `LIKE %s`，参数 `"%牛奶%"` | `LIKE '%%s%'` |
| 占位符只能代替“值”，不能代替表名、列名 | `WHERE stock < %s` | `SELECT * FROM %s` |

第三行的错误写法最隐蔽：`sql % (8,)` 是 Python 自己的字符串格式化，等于又变回了拼接，**一样会被注入**。判断标准只有一个：**SQL 字符串和用户输入，是不是分两个参数交给了 execute。**

表名、列名不能参数化。如果确实要让用户选“按价格排序”还是“按库存排序”，应该在程序里准备一个允许的列表，只接受列表里的值：

```python
allowed = {"价格": "price", "库存": "stock"}           # 白名单
col = allowed.get(user_choice, "product_id")            # 不在名单里就用默认值
cur.execute(f"SELECT name FROM product ORDER BY {col}")
```

## 11.3 在程序里写增删改和事务

### 11.3.1 连接配置不写进代码

上面第一个程序把口令 `App#2026` 直接写在了代码里。代码要给同学看、要上传到 Git 仓库，口令就跟着泄露了。正确的做法是把连接信息写在单独的**配置文件**里，代码只负责读取。配套资源中的 `db_config.ini`：

```ini
; 数据库连接配置。口令不写进代码，写在这里；这个文件不要上传到网上
[mysql]
host = 127.0.0.1
port = 3306
user = shopapp
password = App#2026
database = shop
```

`shopdb.py` 用 Python 自带的 configparser 读取它，返回连接：

```python
import configparser
import pymysql

def get_connection(dict_rows=False):
    cfg = configparser.ConfigParser()
    cfg.read("db_config.ini", encoding="utf-8")       # 读配置文件
    c = cfg["mysql"]
    cursor_class = pymysql.cursors.DictCursor if dict_rows else pymysql.cursors.Cursor
    return pymysql.connect(host=c["host"], port=int(c["port"]), user=c["user"],
                           password=c["password"], database=c["database"],
                           charset="utf8mb4", cursorclass=cursor_class)
```

（配套资源里的版本按 `shopdb.py` 所在的目录找配置文件，在别的目录运行也不会找不到。）以后换服务器、改口令，只改配置文件，不用动代码。用 Git 管理代码时，把 `db_config.ini` 写进 `.gitignore`，另外提交一份口令留空的 `db_config.example.ini` 给别人参考。

### 11.3.2 增删改要提交

PyMySQL 默认**关闭自动提交**，也就是说，连接一打开就处在一个事务里。执行 INSERT、UPDATE、DELETE 之后必须调用 `conn.commit()`，修改才会真正保存；如果不提交就关闭连接，修改会被撤销。

```python
with get_connection() as conn:
    with conn.cursor() as cur:
        cur.execute("UPDATE product SET stock = stock + %s WHERE product_id = %s", (20, 5))
        print("影响行数：", cur.rowcount)          # 改了几行
    conn.commit()                                    # 不写这一句，进货就白录了
```

`cur.rowcount` 是这条语句影响的行数；插入一行后，`cur.lastrowid` 是自增列生成的新编号，相当于第 10 章的 `LAST_INSERT_ID()`。

### 11.3.3 用事务完成下单

第 9 章用 SQL 写过下单事务。在程序里，结构是“**try 里做事，全部成功就 commit；except 里 rollback**”（try / except 的用法见《Python 编程》的异常处理一章）：

```python
def place_order(customer_id, employee_id, items):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO orders (customer_id, employee_id, order_time, pay_method) "
                        "VALUES (%s, %s, NOW(), %s)", (customer_id, employee_id, "微信"))
            order_id = cur.lastrowid                               # 新订单号
            for product_id, qty in items:
                cur.execute("SELECT price, stock FROM product WHERE product_id = %s FOR UPDATE",
                            (product_id,))                         # 读库存并加锁（9.3）
                price, stock = cur.fetchone()
                if stock < qty:
                    raise ValueError(f"商品 {product_id} 库存只有 {stock}，不够 {qty}")
                cur.execute("INSERT INTO order_item VALUES (%s, %s, %s, %s)",
                            (order_id, product_id, qty, price))
                cur.execute("UPDATE product SET stock = stock - %s WHERE product_id = %s",
                            (qty, product_id))
        conn.commit()                                              # 全部成功才提交
        return order_id
    except Exception:
        conn.rollback()                                            # 任何一步出错都回滚
        raise                                                      # 把错误继续报给调用者
    finally:
        conn.close()
```

`SELECT … FOR UPDATE` 在读库存的同时给这一行加锁（第 9 章 9.3 节），防止两个收银台同时卖最后一件。编者先买 2 袋燕麦片，再在同一单里买 1 袋燕麦片和 1 包挂面（挂面库存为 0）：

```text
③ 下单前库存：燕麦片 91 ，挂面 0
   下单成功，订单号 2502 ，燕麦片库存 89
   下单失败： 商品 5 库存只有 0，不够 1
   回滚后库存：燕麦片 89 ，挂面 0
```

第二单里燕麦片那一行其实已经插入了明细、扣了库存，但挂面不够，整单回滚，燕麦片的库存仍是 89，没有被白扣。

## 11.4 pandas 读写数据库

### 11.4.1 read_sql：查询结果直接变成表格

在数据分析课里你会大量使用 pandas 的 DataFrame（二维表格）。pandas 可以直接执行 SQL，把结果变成 DataFrame。pandas 官方文档说明，`read_sql` 接受 SQLAlchemy 的连接对象，普通的 DB-API 连接只支持 sqlite3<sup class="cite">[[3]](#ref11-3)</sup>，所以访问 MySQL 时要先用 SQLAlchemy 建一个“引擎”：

```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine("mysql+pymysql://shopapp:App%232026@127.0.0.1:3306/shop?charset=utf8mb4")
df = pd.read_sql("SELECT name, price, stock FROM product WHERE stock < 10", engine)
print(df)
```

网址形式的连接串里，口令中的 `#` 要写成 `%23`（配套资源的 `shopdb.get_engine()` 会自动处理）。`mysql+pymysql` 的意思是“数据库是 MySQL，驱动用 PyMySQL”。

在 pandas 里（以及用 PyMySQL 带参数执行时），SQL 中的 `%` 有特殊含义：如果 SQL 里有 `DATE_FORMAT(order_time, '%Y-%m')` 这样的百分号，要写成两个：`'%%Y-%%m'`，否则会报 `ValueError: unsupported format character 'Y'`。

### 11.4.2 to_sql：把结果写回数据库

分析好的结果可以用 `to_sql` 写回数据库，变成一张表，会计用自己的只读账号就能查看：

```python
with engine.begin() as conn:                     # begin()：成功自动提交，出错自动回滚
    conn.exec_driver_sql("DELETE FROM monthly_report")
    df.to_sql("monthly_report", conn, if_exists="append", index=False)
```

`if_exists` 有三个取值：`"fail"`（表已存在就报错）、`"replace"`（删表重建）、`"append"`（追加行）。本章的 shopapp 账号没有建表、删表权限，所以先在 `lab11_0_setup.sql` 里用 root 建好表，程序里用 `append`。这也是最小权限原则的体现。

## 11.5 数据挖掘入门：窗口函数

### 11.5.1 GROUP BY 的局限

老板问：“每一类商品里，哪个最贵？排第几？”用第 4 章的 GROUP BY，一组只能剩一行，商品明细就看不到了。[**窗口函数**](../../appendix/glossary.md#g-窗口函数 "对与当前行相关的一组行（窗口）进行计算、但不把多行合并成一行的函数，写作 函数() OVER (PARTITION BY … ORDER BY …)，常用于排名、累计、同比环比"){ .term }能做到**每一行都保留，同时算出它在组里的名次、累计值等**<sup class="cite">[[4]](#ref11-4)</sup>：

```sql
函数名() OVER (PARTITION BY 分组列 ORDER BY 排序列)
```

- `OVER` 表示“这是一个窗口函数”；
- `PARTITION BY` 把行分成若干组（窗口），和 GROUP BY 的分组类似，但**不合并行**；省略时整张表是一个窗口；
- `ORDER BY` 规定窗口里的行按什么顺序计算。

### 11.5.2 排名：ROW_NUMBER、RANK、DENSE_RANK

<div class="sql-try" markdown>

```sql
SELECT c.name AS 类别, p.name AS 商品, p.price AS 售价,
       RANK() OVER (PARTITION BY p.category_id ORDER BY p.price DESC) AS 名次
FROM product p JOIN category c ON p.category_id = c.category_id
WHERE p.category_id IN (2, 5)
ORDER BY p.category_id, 名次;
```

</div>

编者在 MySQL 上的结果：每个类别内部各自从第 1 名排起。

```text
+--------------+------------------------+--------+--------+
| 类别         | 商品                   | 售价   | 名次   |
+--------------+------------------------+--------+--------+
| 早餐冲饮     | 速溶咖啡 40 条         |  45.00 |      1 |
| 早餐冲饮     | 即食豆浆粉 30 包       |  29.90 |      2 |
| 早餐冲饮     | 燕麦片 1kg             |  26.90 |      3 |
| 早餐冲饮     | 芝麻糊 600g            |  18.80 |      4 |
| 早餐冲饮     | 鲜肉包 6 个            |  15.00 |      5 |
| 早餐冲饮     | 全麦面包 400g          |  12.90 |      6 |
| 乳制品       | 纯牛奶 250ml×16        |  52.00 |      1 |
| 乳制品       | 儿童奶酪棒 20 支       |  39.90 |      2 |
| 乳制品       | 原味酸奶 100g×8        |  19.90 |      3 |
| 乳制品       | 低脂牛奶 1L            |  15.50 |      4 |
+--------------+------------------------+--------+--------+
```

三个排名函数的区别在于**遇到并列怎么办**。用“库存最少的商品”来看（库存有并列）：

<div class="sql-try" markdown>

```sql
SELECT name AS 商品, stock AS 库存,
       ROW_NUMBER() OVER (ORDER BY stock, product_id) AS 行号,
       RANK()       OVER (ORDER BY stock) AS 排名,
       DENSE_RANK() OVER (ORDER BY stock) AS 密集排名
FROM product
WHERE stock < 20
ORDER BY stock, product_id;
```

</div>

```text
+-------------------+--------+--------+--------+--------------+
| 商品              | 库存   | 行号   | 排名   | 密集排名     |
+-------------------+--------+--------+--------+--------------+
| 挂面 1kg          |      0 |      1 |      1 |            1 |
| 橙汁 1L           |      0 |      2 |      1 |            1 |
| 原味薯片 104g     |      8 |      3 |      3 |            2 |
| 苹果 1kg          |      8 |      4 |      3 |            2 |
| 火锅底料 200g     |      8 |      5 |      3 |            2 |
| 保鲜膜 30m        |     13 |      6 |      6 |            3 |
+-------------------+--------+--------+--------+--------------+
```

| 函数 | 并列时 | 本例的名次 | 常见用途 |
|---|---|---|---|
| ROW_NUMBER | 不并列，按顺序编号 | 1, 2, 3, 4, 5, 6 | 每组取前 N 条、分页 |
| RANK | 并列同名次，后面**跳号** | 1, 1, 3, 3, 3, 6 | 比赛排名 |
| DENSE_RANK | 并列同名次，后面**不跳号** | 1, 1, 2, 2, 2, 3 | 等级划分 |

ROW_NUMBER 遇到库存相同的商品，谁先谁后是不确定的，所以 ORDER BY 里加了 product_id，保证每次结果一样。

“每类取前 2 名”是最常见的需求，窗口函数不能直接写在 WHERE 里（WHERE 比窗口函数先执行，回忆第 4 章的执行顺序），要先在 WITH 里算好名次，外面再筛选：

```sql
WITH s AS (
  SELECT category_id, name, price,
         ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rn
  FROM product
)
SELECT * FROM s WHERE rn <= 2;
```

### 11.5.3 累计与环比：SUM() OVER 与 LAG

聚合函数加上 OVER 也能当窗口函数用。`SUM(…) OVER (ORDER BY 月份)` 算的是“从第一个月到当前月”的累计值：

<div class="sql-try" markdown>

```sql
SELECT DATE_FORMAT(o.order_time, '%Y-%m') AS 月份,
       SUM(i.quantity * i.unit_price) AS 销售额,
       SUM(SUM(i.quantity * i.unit_price))
         OVER (ORDER BY DATE_FORMAT(o.order_time, '%Y-%m')) AS 累计,
       LAG(SUM(i.quantity * i.unit_price))
         OVER (ORDER BY DATE_FORMAT(o.order_time, '%Y-%m')) AS 上月
FROM orders o JOIN order_item i ON o.order_id = i.order_id
WHERE o.status = '已完成' AND o.order_time >= '2026-01-01'
GROUP BY 月份
ORDER BY 月份;
```

</div>

编者在 MySQL 上的结果：

```text
+---------+-----------+----------+----------+
| 月份    | 销售额    | 累计     | 上月     |
+---------+-----------+----------+----------+
| 2026-01 |  10125.50 | 10125.50 |     NULL |
| 2026-02 |  10021.40 | 20146.90 | 10125.50 |
| 2026-03 |  11238.70 | 31385.60 | 10021.40 |
| 2026-04 |   9989.30 | 41374.90 | 11238.70 |
| 2026-05 |   9936.40 | 51311.30 |  9989.30 |
| 2026-06 |  11241.30 | 62552.60 |  9936.40 |
+---------+-----------+----------+----------+
```

- `SUM(SUM(…)) OVER (…)`：里面的 SUM 是 GROUP BY 的分组求和（每月销售额），外面的 SUM 是窗口函数（把每月销售额逐月累加）。看着绕，可以理解成“先分组，再在分组结果上开窗”；
- `LAG(x)` 取**上一行**的 x，第一行没有上一行，所以是 NULL。对应的 `LEAD(x)` 取下一行；
- 有了“上月”，环比增长率就是 `(销售额 - 上月) / 上月 × 100`。

窗口函数是 SQL 做数据分析的利器，它和 pandas 结合，可以完成很多“数据挖掘”的入门工作。

### 11.5.4 用 SQL + pandas 做月度销售分析

[**数据挖掘**](../../appendix/glossary.md#g-数据挖掘 "从大量数据中发现有用的规律和知识的过程，如找出畅销商品、销售趋势、经常一起购买的商品等"){ .term }是从大量数据里发现有用的规律，比如哪些商品卖得好、销售额怎么变化、哪些商品经常一起买（第 5 章实验 5-3 做过“一起买”）。本节做一份小店 2026 年上半年的月度销售分析，分工是：

- **SQL** 负责“在数据旁边算”：筛选、连接、分组、窗口函数，把几千行明细浓缩成几行结果；
- **pandas** 负责“拿到结果再加工”：再分组、排序、画图、导出。

实验 11-2 的程序 `lab11_2_sales_analysis.py` 依次完成：① 用 WITH + LAG + SUM() OVER 算出每月订单数、销售额、累计和环比；② 用 ROW_NUMBER 找出每个类别销售额前 2 名的商品；③ 用 pandas 的 groupby 再汇总；④ 画出月度销售柱状图；⑤ 把结果写回 monthly_report 表。运行结果见实验 11-2，画出的图如下：

![社区小店 2026 年上半年月度销售额柱状图](images/monthly_sales.png){ width="600" }

图 11-1 用 pandas 和 matplotlib 画出的月度销售额（只统计已完成的订单）

从图上能看出：3 月和 6 月销售额较高，4、5 月略低。为什么？是节假日、促销，还是天气？这些问题要结合业务去分析，更深入的方法在《人工智能数据分析与处理》课程中学习。

## 11.6 一个完整的小应用：小店管理助手

### 11.6.1 分层：界面、业务、数据

做一个给老板和收银员用的程序，最忌讳在按钮的代码里到处写 SQL。好的做法是**分层**：

```mermaid
flowchart TB
  UI["界面层 lab11_3_app.py<br/>按钮、输入框、表格、图表"] --> SVC["业务层 shop_service.py<br/>search_products、place_order、monthly_sales"]
  SVC --> DB["数据访问 shopdb.py<br/>读配置、建连接"]
  DB --> MYSQL[("MySQL<br/>shop 库")]
```

- **界面层**只管显示和接收输入，不写一句 SQL；
- **业务层**把“查商品”“下单”这样的业务写成函数，SQL 和事务都在这里；
- **数据访问层**管连接。换数据库、换口令只改这一层。

这样分层以后，同一个 `place_order` 函数既能给网页界面用，也能给命令行程序、微信小程序后台用，出了问题也容易定位。

### 11.6.2 用 Streamlit 做界面

[Streamlit](https://docs.streamlit.io/get-started) 是一个用纯 Python 写网页界面的库<sup class="cite">[[5]](#ref11-5)</sup>，不用学 HTML。界面层的全部代码不到 40 行，核心部分：

```python
import streamlit as st
import shop_service as svc

st.title("🛒 社区小店管理助手")
page = st.sidebar.radio("功能", ["查商品", "录订单", "看报表"])   # 左侧菜单

if page == "查商品":
    kw = st.text_input("商品名称关键字", "牛奶")                    # 输入框
    st.dataframe(svc.search_products(kw), hide_index=True)          # 表格
elif page == "录订单":
    product_id = st.number_input("商品编号", min_value=1, value=8)
    qty = st.number_input("数量", min_value=1, value=1)
    if st.button("提交订单"):                                       # 按钮
        try:
            oid = svc.place_order(1, 3, [(int(product_id), int(qty))])
            st.success(f"下单成功，订单号 {oid}")
        except Exception as e:
            st.error(f"下单失败，已回滚：{e}")
else:
    df = svc.monthly_sales()
    st.bar_chart(df, x="月份", y="销售额")                          # 柱状图
```

在命令提示符里运行 `streamlit run lab11_3_app.py`，浏览器会自动打开 `http://localhost:8501`。编者运行的界面：

![小店管理助手的查商品页面](images/app_products.png){ width="600" }

图 11-2 “查商品”页面：输入关键字查商品，下方列出库存不足 10 件的商品

![小店管理助手的录订单页面，下单失败](images/app_order_fail.png){ width="600" }

图 11-3 “录订单”页面：挂面库存为 0，下单失败，整单回滚

![小店管理助手的看报表页面](images/app_report.png){ width="600" }

图 11-4 “看报表”页面：读取第 8 章建的月度销售视图并画图

注意 `search_products` 里查商品用的是参数化查询，老板在输入框里输入什么都不会造成注入。

## 11.7 前沿视窗：ORM 与 Text-to-SQL 智能助手

**ORM。**本章的程序里，SQL 还是我们自己写的。大型项目常用 [**ORM**](../../appendix/glossary.md#g-ORM "对象关系映射（Object-Relational Mapping），把数据库的表映射成程序里的类、行映射成对象，让程序员用操作对象的方式读写数据库，由框架自动生成 SQL"){ .term }（对象关系映射）框架，把一张表映射成程序里的一个“类”，一行映射成一个“对象”，读写数据像操作 Python 对象一样，SQL 由框架自动生成。Python 中常用的 ORM 有 SQLAlchemy（本章已经用到它的引擎）和 Django 自带的 ORM。ORM 写起来快，也天然使用参数化查询；但复杂的统计查询往往还是直接写 SQL 更清楚、更快。**懂 SQL 是用好 ORM 的前提。**

**Text-to-SQL。**第 1 章前沿视窗提过：让大模型把“上个月哪个类别卖得最好”翻译成 SQL。学术界从 2018 年的 Spider 数据集<sup class="cite">[[6]](#ref11-6)</sup>开始系统评测这种能力，现在的大模型在常见查询上已经相当准确。把它接到本章的小店助手上，老板就能直接打字提问。但要注意三件事：

1. 大模型生成的 SQL **可能是错的**，而且错得“看起来很对”，结果要能被核对；
2. 给它用的数据库账号**只能有查询权限**（第 10 章的最小权限原则），防止一句“帮我清理一下旧订单”变成 DELETE；
3. 用户的提问也可能夹带恶意指令（提示词注入），和 SQL 注入是同一类问题。

接入大模型的具体方法在自然语言处理和智能体开发课程中学习。

## 本章实验

!!! abstract "实验总览"
    | 实验 | 类型 | 建议时长 | 内容 |
    |---|---|---|---|
    | 实验 11-1 | ★ 基础 | 45 分钟 | 用 PyMySQL 完成查询、插入和事务下单，对比拼接与参数化 |
    | 实验 11-2 | ★ 基础 | 45 分钟 | 用窗口函数和 pandas 做月度销售分析 |
    | 实验 11-3 | ☆ 拓展 | 90 分钟 | 运行并扩展 Streamlit 版小店管理助手 |

    代码见配套资源 `labs/ch11/` 目录。三个实验共用 `db_config.ini` 和 `shopdb.py`，运行前先用 root 执行一次 `lab11_0_setup.sql`。

### 实验 11-1 ★ 用 PyMySQL 查询、插入和事务下单

**实验目的**

1. 掌握连接、游标、执行、取结果、关闭的完整流程；
2. 会在程序里用 commit 和 rollback 实现事务；
3. 亲眼看到拼接字符串和参数化查询的差别。

**实验环境**：本机 Python 3.11 及以上 + MySQL 8.4（或 Docker 环境）。**实验数据**：示例库 shop。

**实验步骤与代码**

1. 安装库：`pip install pymysql cryptography`；
2. 用 root 运行 `labs/ch11/lab11_0_setup.sql`，建账号 shopapp；打开 `db_config.ini`，确认主机、端口和你的环境一致；
3. 在命令提示符里进入 `labs/ch11` 目录，运行 `python lab11_1_pymysql.py`。程序分三段：① 查商品总数和库存不足的商品；② 用 DictCursor 查名字里有“牛奶”的商品；③ 调用 `place_order` 下两单，第二单故意包含库存为 0 的挂面；
4. 运行 `python lab11_1_injection.py`，对比两种写法；
5. 动手改：把 `lab11_1_pymysql.py` 里查库存不足的阈值从 10 改成 20，再运行；在 `place_order` 里把 `conn.commit()` 注释掉，再下一单，查一查订单表里有没有这一单。

**运行结果**

编者的运行结果（第一次运行，shop 库为初始状态）：

```text
① 商品总数： 48
   库存不足：挂面 1kg  8.50 元  剩 0
   库存不足：橙汁 1L  13.80 元  剩 0
   库存不足：原味薯片 104g  8.90 元  剩 8
   库存不足：苹果 1kg  12.80 元  剩 8
   库存不足：火锅底料 200g  19.90 元  剩 8
② 名字里有“牛奶”的商品： [{'product_id': 25, 'name': '纯牛奶 250ml×16', 'price': Decimal('52.00')}, {'product_id': 26, 'name': '低脂牛奶 1L', 'price': Decimal('15.50')}]
③ 下单前库存：燕麦片 91 ，挂面 0
   下单成功，订单号 2502 ，燕麦片库存 89
   下单失败： 商品 5 库存只有 0，不够 1
   回滚后库存：燕麦片 89 ，挂面 0
```

再运行一次时，订单号和燕麦片库存会变化（订单号还会跳过一个，因为失败那一单回滚了，但自增编号已经用掉了）。第 4 步的结果见 11.2.1 节。

**实验记录表**

| 步骤 | 观察内容 | 你的结果 |
|---|---|---|
| ③ | 第一单的订单号、下单后燕麦片库存 | |
| ③ | 第二单失败的原因、回滚后燕麦片库存 | |
| 4 | 输入注入串时，两种写法各查到几行 | |
| 5 | 注释掉 commit 后，订单表里有没有新订单 | |

**常见问题排查**

| 现象 | 原因 | 解决办法 |
|---|---|---|
| `ModuleNotFoundError: No module named 'pymysql'` | 没装库，或装到了另一个 Python 里 | 用 `python -m pip install pymysql` 安装，保证和运行程序的是同一个 Python |
| `RuntimeError: 'cryptography' package is required` | MySQL 8 默认的口令验证方式需要这个库 | `pip install cryptography` |
| `OperationalError: (2003, "Can't connect to MySQL server …")` | MySQL 没启动，或主机、端口写错 | 检查服务（10.1.3）和 db_config.ini |
| `OperationalError: (1045, "Access denied for user 'shopapp'…")` | 没运行 lab11_0_setup.sql，或口令不对 | 用 root 运行建账号脚本 |
| 中文变成问号 | 连接时没写 charset="utf8mb4" | 使用 shopdb.get_connection() |
| `KeyError: 'mysql'` | 找不到 db_config.ini，或文件不是 UTF-8 编码 | 确认文件和 shopdb.py 在同一目录，用 UTF-8 保存 |

**思考与练习**

1. 第 5 步注释掉 commit 以后，程序没有报错，为什么订单却没有保存？
2. 把 `place_order` 中的 `raise ValueError(…)` 换成 `return None`（不抛异常），会出现什么问题？

**实验报告要求**

完成实验记录表，截图第 3、4 步的运行结果，回答思考题。

### 实验 11-2 ★ 用窗口函数和 pandas 做月度销售分析

**实验目的**

1. 会用 ROW_NUMBER、SUM() OVER、LAG 完成排名、累计和环比；
2. 会用 pandas 的 read_sql 读取查询结果、用 to_sql 写回数据库，并画图。

**实验环境**：同实验 11-1，另需 `pip install sqlalchemy pandas matplotlib`。**实验数据**：示例库 shop。

**实验步骤与代码**

1. 先在 DBeaver 里运行 11.5 节的三条窗口函数查询（也可以在网页“试一试”里运行），理解每一列的含义；
2. 运行 `python lab11_2_sales_analysis.py`。月度分析的 SQL 如下（在 pandas 中，`%` 要写成 `%%`）：

```sql
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
```

3. 打开生成的 `monthly_sales.png`；在 DBeaver 里用会计账号或 root 查询 `SELECT * FROM monthly_report;`；
4. 动手改：把“每类前 2 名”改成“每类前 3 名”；把柱状图改成折线图（`kind="line"`）。

**运行结果**

编者的运行结果：

```text
① 2026 年上半年月度销售
  month  orders   sales  running_total  growth
2026-01     137 10125.5        10125.5    -2.2
2026-02     123 10021.4        20146.9    -1.0
2026-03     138 11238.7        31385.6    12.1
2026-04     135  9989.3        41374.9   -11.1
2026-05     141  9936.4        51311.3    -0.5
2026-06     139 11241.3        62552.6    13.1

② 各类别销售额前 2 名（节选前 6 行）
category      product  sales  rn
    粮油米面       花生油 5L 4895.0   1
    休闲零食  每日坚果 25g×30 4752.0   1
    早餐冲饮    速溶咖啡 40 条 4140.0   1
    粮油米面       菜籽油 5L 3965.0   2
     乳制品 纯牛奶 250ml×16 3328.0   1
     乳制品   儿童奶酪棒 20 支 2473.8   2

③ 前 2 名合计最高的 3 个类别（pandas 分组求和）
粮油米面    8860.0
休闲零食    6397.0
早餐冲饮    6265.1

④ 图已保存为 monthly_sales.png
⑤ monthly_report 表中写入 6 行，内容与①相同（不含 running_total 列）
```

2026 年 1 月的环比 −2.2% 是和 2025 年 12 月比较得到的，所以 SQL 里多取了 12 月的数据，最后再筛掉。pandas 读出的销售额显示为 10125.5 这样的小数，只是显示格式不同，数值和 MySQL 里的 10125.50 一样。

**实验记录表**

| 问题 | 你的结果 |
|---|---|
| 上半年销售额最高的月份和金额 | |
| 环比下降最多的月份和降幅 | |
| 上半年累计销售额 | |
| 改成每类前 3 名后，“粮油米面”的第 3 名是 | |

**常见问题排查**

| 现象 | 原因 | 解决办法 |
|---|---|---|
| `ValueError: unsupported format character 'Y' (0x59) …` | SQL 里的 `%` 没有写成 `%%` | DATE_FORMAT、LIKE 里的百分号都写两个 |
| 图上的中文是方框 | matplotlib 没找到中文字体 | Windows 用 "Microsoft YaHei" 或 "SimHei"，程序开头已设置 |
| to_sql 报 `INSERT command denied` | shopapp 没有 monthly_report 的写权限 | 用 root 重新运行 lab11_0_setup.sql |
| 出现 `UserWarning: pandas only supports SQLAlchemy connectable (engine/connection) or database string URI or sqlite3 DBAPI2 connection …` | 把 PyMySQL 的连接直接交给了 read_sql | 改用 `get_engine()` 返回的 SQLAlchemy 引擎 |

**思考与练习**

1. 为什么“每类前 2 名”不能写成 `WHERE ROW_NUMBER() OVER (…) <= 2`？
2. 本实验哪些计算放在 SQL 里做，哪些放在 pandas 里做？如果订单表有 1 亿行，你会怎样分工？

**实验报告要求**

完成实验记录表，附上生成的图（或改成折线图后的图），回答思考题。

### 实验 11-3 ☆ Streamlit 版小店管理助手

**实验目的**

1. 体会界面、业务、数据访问分层的写法；
2. 能在已有程序上增加一个新功能。

**实验环境**：同实验 11-1，另需 `pip install streamlit`。**实验数据**：示例库 shop；需要第 8 章建的视图 v_monthly_sales。

**实验步骤与代码**

1. 在 `labs/ch11` 目录运行 `streamlit run lab11_3_app.py`，浏览器打开后依次试用三个功能；
2. 在“录订单”页面：商品编号 8、数量 1，提交；再把商品编号改成 5（挂面，库存 0），提交，观察提示；
3. 阅读 `shop_service.py`，找到 `place_order` 函数，和实验 11-1 中的同名函数比较，多了哪些检查；
4. 扩展（任选一项）：
    - 在“查商品”页面增加一个下拉框，按类别筛选商品（提示：业务层新增一个函数，SQL 里用参数化的 `WHERE c.name = %(cat)s`）；
    - 在“录订单”页面一次录入多种商品；
    - 增加“会员查询”页面，手机号用第 10 章的脱敏写法显示。

**运行结果**

编者的运行结果见图 11-2 到图 11-4。第 2 步第一次提交显示“下单成功，订单号 2502”（数据库为初始状态时），第二次显示“下单失败，已回滚：挂面 1kg 库存只有 0，不够 1”。

**实验记录表**

| 步骤 | 观察内容 | 你的结果 |
|---|---|---|
| 2 | 两次提交的提示 | |
| 3 | 业务层的 place_order 比实验 11-1 多了什么检查 | |
| 4 | 你选做的扩展、改了哪几个文件 | |

**常见问题排查**

| 现象 | 原因 | 解决办法 |
|---|---|---|
| “streamlit 不是内部或外部命令” | Python 的 Scripts 目录不在 Path 里 | 改用 `python -m streamlit run lab11_3_app.py` |
| 浏览器没有自动打开 | 系统默认浏览器设置问题 | 手动打开命令行里显示的 Local URL |
| “看报表”页面报 v_monthly_sales 不存在 | 没有运行第 8 章的建视图脚本 | 运行 `labs/ch08/lab8_1_views.sql` |
| 改了代码页面没变化 | Streamlit 要重新运行 | 页面右上角点 Rerun，或按键盘 R |

**思考与练习**

1. 如果把 SQL 直接写在界面层的按钮代码里，以后要把界面换成微信小程序，会遇到什么麻烦？
2. 这个程序用 shopapp 账号连接数据库。如果有人拿到了这个程序和配置文件，最多能对数据库做什么？

**实验报告要求**

截图三个页面和你扩展的功能，附上修改的代码，回答思考题。

## 本章小结

- 程序访问数据库五步：**连接 → 游标 → 执行 → 取结果 → 关闭**。Python 访问 MySQL 用 **PyMySQL** 驱动；用 with 自动关闭；DictCursor 按列名取值。
- **参数化查询**：SQL 里用 `%s` 占位，值作为 execute 的第二个参数单独传入，驱动会转义，是防 SQL 注入的首要办法；占位符外不加引号；表名、列名不能参数化，要用白名单。
- PyMySQL 默认不自动提交，增删改后要 **commit**；事务写成 try 里做事、成功 commit、except 里 **rollback**。连接信息写在**配置文件**里，不写进代码、不上传。
- **pandas**：`read_sql` 配合 SQLAlchemy 引擎把查询结果变成 DataFrame；`to_sql` 写回数据库；SQL 里的 `%` 写成 `%%`。
- **窗口函数** `函数() OVER (PARTITION BY … ORDER BY …)` 不合并行：**ROW_NUMBER** 不并列、**RANK** 并列跳号、**DENSE_RANK** 并列不跳号；`SUM() OVER` 算累计，**LAG** 取上一行算环比；筛选名次要先在 WITH 里算好。
- 应用要**分层**：界面层不写 SQL，业务层写 SQL 和事务，数据访问层管连接。**ORM** 自动生成 SQL；Text-to-SQL 要配只读账号、核对结果。

```mermaid
mindmap
  root((第 11 章<br/>Python 数据库应用))
    访问五步
      连接
      游标
      执行
      取结果
      关闭
    安全
      参数化查询
      白名单
      配置文件
      专用账号
    事务
      commit
      rollback
      FOR UPDATE
    pandas
      read_sql
      to_sql
      画图
    窗口函数
      ROW_NUMBER
      RANK DENSE_RANK
      SUM OVER 累计
      LAG 环比
    小应用
      分层
      Streamlit
      ORM
      Text-to-SQL
```

**下一章预告**

顾客在小程序里搜“适合老人吃的软一点的早餐”，用 `LIKE '%早餐%'` 怎么也找不到燕麦片和小米粥，因为关键词对不上。第 12 章学习向量数据库：把文字变成一串数字，“按意思”而不是“按字面”找东西，这也是大模型知识库背后的技术。

## 参考文献

正文中的上标编号（如<sup class="cite">[[2]](#ref11-2)</sup>）对应下面的文献。带链接的可以直接打开；书籍可在图书馆或电子书平台查阅。

<div class="refs" markdown>

**经典论文与规范**

- <span id="ref11-1"></span>[1] LEMBURG M-A. PEP 249 – Python Database API Specification v2.0[EB/OL]. [2026-11-01]. https://peps.python.org/pep-0249/.
    <span class="ref-note">Python 数据库接口规范，定义了 connect、cursor、execute、fetchone、fetchall、commit、rollback 和 %s 等参数风格，对应 11.1 节。</span>
- <span id="ref11-6"></span>[6] YU T, ZHANG R, YANG K, et al. Spider: a large-scale human-labeled dataset for complex and cross-domain semantic parsing and text-to-SQL task[C]//Proceedings of the 2018 Conference on Empirical Methods in Natural Language Processing. Brussels: Association for Computational Linguistics, 2018: 3911-3921.
    <span class="ref-note">Text-to-SQL 领域影响最大的评测数据集之一，对应 11.7 节。</span>

**在线资源与数据**

- <span id="ref11-2"></span>[2] OWASP Foundation. SQL Injection Prevention Cheat Sheet[EB/OL]. [2026-11-01]. https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html.
    <span class="ref-note">国际开放 Web 应用安全项目的 SQL 注入防护指南，把参数化查询列为首要防御手段，对应 11.2 节。</span>
- <span id="ref11-3"></span>[3] pandas development team. pandas.read_sql[EB/OL]. [2026-11-01]. https://pandas.pydata.org/docs/reference/api/pandas.read_sql.html.
    <span class="ref-note">read_sql 的参数说明，指出 DB-API 连接只支持 sqlite3，其他数据库通过 SQLAlchemy 连接，对应 11.4 节。</span>
- <span id="ref11-4"></span>[4] Oracle. MySQL 8.4 Reference Manual: Window Functions[EB/OL]. [2026-11-01]. https://dev.mysql.com/doc/refman/8.4/en/window-functions.html.
    <span class="ref-note">MySQL 窗口函数的完整说明，包括 ROW_NUMBER、RANK、DENSE_RANK、LAG、LEAD 和窗口框架，对应 11.5 节。</span>
- <span id="ref11-5"></span>[5] Snowflake Inc. Get started with Streamlit[EB/OL]. [2026-11-01]. https://docs.streamlit.io/get-started.
    <span class="ref-note">Streamlit 官方入门文档，对应 11.6.2 节和实验 11-3。</span>
- <span id="ref11-7"></span>[7] PyMySQL contributors. PyMySQL[EB/OL]. [2026-11-01]. https://pypi.org/project/PyMySQL/.
    <span class="ref-note">PyMySQL 的安装说明和示例，示例代码同样使用 %s 参数化写法，对应 11.1、11.3 节。</span>

</div>

## 课后练习

选择题和判断题可以直接点击选项作答，系统会马上告诉你对错，并展开答案与解析；多选题选好后点“提交答案”。简答和实操题请先自己作答，再点开“答案与解析”核对。每道题的解析下方都有“回看”链接，做错了可以直接跳回正文复习。

**一、单项选择题**

<div class="quiz" data-answer="B" markdown>

**1.** 用 Python 程序访问数据库，正确的步骤顺序是（　　）。

- A. 游标 → 连接 → 执行 → 取结果 → 关闭
- B. 连接 → 游标 → 执行 → 取结果 → 关闭
- C. 执行 → 连接 → 游标 → 关闭 → 取结果
- D. 连接 → 执行 → 关闭 → 游标 → 取结果

</div>

??? tip "答案与解析"
    **答案：B**

    考查：访问数据库的步骤 · 认知层次：记忆 · [回看 11.1.1](#1111)
    { .quiz-meta }

<div class="quiz" data-answer="C" markdown>

**2.** 执行 `SELECT COUNT(*) FROM student` 后，要取出这个计数值，最合适的是（　　）。

- A. `cur.fetchall()`
- B. `cur.rowcount`
- C. `cur.fetchone()[0]`
- D. `conn.commit()`

</div>

??? tip "答案与解析"
    **答案：C**

    查询结果只有一行一列，fetchone() 取出这一行（元组），[0] 取第一列。

    考查：取结果 · 认知层次：应用 · [回看 11.1.2](#1112)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**3.** 下列 PyMySQL 写法中，能够防止 SQL 注入的是（　　）。

- A. `cur.execute("SELECT * FROM student WHERE sno = %s", (sno,))`
- B. `cur.execute("SELECT * FROM student WHERE sno = '" + sno + "'")`
- C. `cur.execute("SELECT * FROM student WHERE sno = '%s'" % sno)`
- D. `cur.execute(f"SELECT * FROM student WHERE sno = '{sno}'")`

</div>

??? tip "答案与解析"
    **答案：A**

    B、C、D 都是先由 Python 把输入拼进字符串，再交给数据库，都会被注入。只有 A 把 SQL 和参数分开传给 execute。

    考查：参数化查询 · 认知层次：应用 · [回看 11.2.2](#1122)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**4.** 用 PyMySQL 执行了一条 UPDATE，程序没有报错，但数据库里的数据没有变化，最可能的原因是（　　）。

- A. 没有调用 fetchall()
- B. 没有使用 DictCursor
- C. 没有设置 charset
- D. 没有调用 conn.commit()

</div>

??? tip "答案与解析"
    **答案：D**

    PyMySQL 默认关闭自动提交，增删改后要 commit，否则关闭连接时修改被撤销。

    考查：提交 · 认知层次：理解 · [回看 11.3.2](#1132)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**5.** 把数据库口令写在配置文件里而不是代码里，主要目的是（　　）。

- A. 让程序运行更快
- B. 避免口令随代码泄露，并且改口令时不用改代码
- C. 让数据库不需要口令
- D. 防止 SQL 注入

</div>

??? tip "答案与解析"
    **答案：B**

    考查：连接配置 · 认知层次：理解 · [回看 11.3.1](#1131)
    { .quiz-meta }

<div class="quiz" data-answer="C" markdown>

**6.** 成绩 95、90、90、85 用 `RANK() OVER (ORDER BY grade DESC)` 排名，得到的名次依次是（　　）。

- A. 1, 2, 3, 4
- B. 1, 2, 2, 3
- C. 1, 2, 2, 4
- D. 1, 1, 2, 3

</div>

??? tip "答案与解析"
    **答案：C**

    RANK 并列同名次，后面跳号；DENSE_RANK 的结果是 1, 2, 2, 3；ROW_NUMBER 是 1, 2, 3, 4。

    考查：排名函数 · 认知层次：应用 · [回看 11.5.2](#1152-row_numberrankdense_rank)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**7.** 在窗口函数中，`PARTITION BY` 的作用是（　　）。

- A. 把行分成若干组，每组单独计算，但不合并行
- B. 把每组合并成一行
- C. 对结果排序
- D. 筛选满足条件的行

</div>

??? tip "答案与解析"
    **答案：A**

    这正是窗口函数与 GROUP BY 的区别。

    考查：窗口函数 · 认知层次：理解 · [回看 11.5.1](#1151-group-by)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**8.** 要在每个月的销售额旁边显示上个月的销售额，应使用（　　）。

- A. ROW_NUMBER()
- B. SUM() OVER
- C. LEAD()
- D. LAG()

</div>

??? tip "答案与解析"
    **答案：D**

    LAG 取上一行，LEAD 取下一行，SUM() OVER (ORDER BY …) 算累计。

    考查：LAG · 认知层次：记忆 · [回看 11.5.3](#1153-sum-over-lag)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**9.** 用 pandas 的 read_sql 读取 MySQL 中的数据，SQL 里包含 `DATE_FORMAT(t, '%Y-%m')`，应当写成（　　）。

- A. `DATE_FORMAT(t, '\%Y-\%m')`
- B. `DATE_FORMAT(t, '%%Y-%%m')`
- C. `DATE_FORMAT(t, 'YYYY-MM')`
- D. 不需要任何改动

</div>

??? tip "答案与解析"
    **答案：B**

    经过 PyMySQL 执行时，`%` 是参数占位符的标记，字面的百分号要写成两个。

    考查：pandas 读数据库 · 认知层次：应用 · [回看 11.4.1](#1141-read_sql)
    { .quiz-meta }

**二、多项选择题**

<div class="quiz" data-answer="ACD" data-multi markdown>

**10.** 关于参数化查询，下列说法正确的有（　　）。

- A. 占位符外面不需要加引号
- B. 表名也可以用 %s 参数化
- C. 用户输入中的引号会被转义，不会改变 SQL 的结构
- D. 参数要作为 execute 的第二个参数传入

</div>

??? tip "答案与解析"
    **答案：ACD**

    占位符只能代替值，不能代替表名、列名；需要动态表名、列名时用白名单。

    考查：参数化查询 · 认知层次：理解 · [回看 11.2.2](#1122)
    { .quiz-meta }

<div class="quiz" data-answer="ABD" data-multi markdown>

**11.** 在程序中实现下单事务时，下列做法正确的有（　　）。

- A. 所有步骤都成功后再调用 commit
- B. 出现异常时调用 rollback
- C. 每执行一条 SQL 就 commit 一次
- D. 读库存时用 SELECT … FOR UPDATE 加锁

</div>

??? tip "答案与解析"
    **答案：ABD**

    每条都 commit 就失去了事务“要么全做要么全不做”的作用。

    考查：程序中的事务 · 认知层次：应用 · [回看 11.3.3](#1133)
    { .quiz-meta }

<div class="quiz" data-answer="BC" data-multi markdown>

**12.** 关于窗口函数，下列说法正确的有（　　）。

- A. 窗口函数可以直接写在 WHERE 子句中
- B. 使用窗口函数后，原来的每一行都保留
- C. 聚合函数 SUM 加上 OVER 可以作为窗口函数使用
- D. 窗口函数只能在 MySQL 中使用

</div>

??? tip "答案与解析"
    **答案：BC**

    A 错：WHERE 先于窗口函数执行，要先在子查询或 WITH 中算好再筛选。D 错：PostgreSQL、SQLite、SQL Server 等都支持。

    考查：窗口函数 · 认知层次：理解 · [回看 11.5.2](#1152-row_numberrankdense_rank)
    { .quiz-meta }

<div class="quiz" data-answer="ABC" data-multi markdown>

**13.** 让大模型根据自然语言生成 SQL 并在小店数据库上执行，应当采取的措施有（　　）。

- A. 使用只有查询权限的数据库账号
- B. 对生成的 SQL 和结果进行核对
- C. 防范用户提问中夹带的恶意指令
- D. 使用 root 账号，以免查询失败

</div>

??? tip "答案与解析"
    **答案：ABC**

    考查：Text-to-SQL · 认知层次：评价 · [回看 11.7](#117-orm-text-to-sql)
    { .quiz-meta }

**三、判断题**

<div class="quiz" data-answer="B" data-judge markdown>

**14.** 只要把 SQL 字符串和参数用 `%` 运算符拼在一起，例如 `cur.execute(sql % (sno,))`，就属于参数化查询。

- A. 正确
- B. 错误

</div>

??? tip "答案与解析"
    **答案：错误**

    `sql % (sno,)` 是 Python 的字符串格式化，在交给 execute 之前已经拼好了，仍会被注入。

    考查：参数化查询 · 认知层次：理解 · [回看 11.2.2](#1122)
    { .quiz-meta }

<div class="quiz" data-answer="A" data-judge markdown>

**15.** 插入一行后，PyMySQL 游标的 lastrowid 属性可以取得自增列生成的编号。

- A. 正确
- B. 错误

</div>

??? tip "答案与解析"
    **答案：正确**

    考查：增删改 · 认知层次：记忆 · [回看 11.3.2](#1132)
    { .quiz-meta }

<div class="quiz" data-answer="B" data-judge markdown>

**16.** DENSE_RANK 遇到并列名次时，后面的名次会跳号。

- A. 正确
- B. 错误

</div>

??? tip "答案与解析"
    **答案：错误**

    跳号的是 RANK；DENSE_RANK 不跳号。

    考查：排名函数 · 认知层次：记忆 · [回看 11.5.2](#1152-row_numberrankdense_rank)
    { .quiz-meta }

<div class="quiz" data-answer="A" data-judge markdown>

**17.** 应用程序分层后，界面层不直接写 SQL，而是调用业务层的函数。

- A. 正确
- B. 错误

</div>

??? tip "答案与解析"
    **答案：正确**

    考查：分层 · 认知层次：理解 · [回看 11.6.1](#1161)
    { .quiz-meta }

<div class="quiz" data-answer="B" data-judge markdown>

**18.** 使用了 ORM 框架，程序员就完全不需要懂 SQL 了。

- A. 正确
- B. 错误

</div>

??? tip "答案与解析"
    **答案：错误**

    ORM 生成的 SQL 是否高效、复杂统计怎么写，仍然需要懂 SQL 才能判断。

    考查：ORM · 认知层次：评价 · [回看 11.7](#117-orm-text-to-sql)
    { .quiz-meta }

**四、简答题**

**1.** 说明数据库驱动、连接、游标三者的作用和关系。

??? tip "答案与解析"
    **参考答案：**驱动是让程序能和某种数据库通信的软件库（如 PyMySQL）；程序通过驱动建立与数据库服务器的连接，连接是通信通道，事务在连接上提交或回滚；在连接上创建游标，用游标执行 SQL、逐行读取结果。一个程序可以有多个连接，一个连接上可以有多个游标。

    考查：驱动、连接与游标 · 认知层次：理解 · [回看 11.1.1](#1111)
    { .quiz-meta }

**2.** 什么是窗口函数？它和 GROUP BY 分组统计有什么不同？举一个适合用窗口函数的例子。

??? tip "答案与解析"
    **参考答案：**窗口函数对与当前行相关的一组行（窗口）进行计算，结果附在每一行上，不合并行，写作 `函数() OVER (PARTITION BY … ORDER BY …)`。GROUP BY 把每组合并成一行，明细就看不到了。例子：在每门课程内按成绩给学生排名（RANK() OVER (PARTITION BY cno ORDER BY grade DESC)），既要看到每个学生，又要知道他在本课程的名次。

    考查：窗口函数 · 认知层次：理解 · [回看 11.5.1](#1151-group-by)
    { .quiz-meta }

**3.** 某同学写的选课程序中，按钮代码里直接用拼接字符串写了 SQL，数据库连接使用 root 账号，口令写在代码第一行。指出其中的问题并提出改进办法。

??? tip "答案与解析"
    **参考答案：**① 拼接字符串会造成 SQL 注入，应改为参数化查询；② 使用 root 违反最小权限原则，被注入或程序被盗时损失极大，应建立专用账号，只授予需要的权限；③ 口令写在代码里会随代码泄露，应写在配置文件中，配置文件不上传；④ SQL 写在按钮代码里不利于维护，应分层，把 SQL 和事务放在业务层函数中。

    考查：程序安全与分层 · 认知层次：评价 · [回看 11.6.1](#1161)
    { .quiz-meta }

**五、实操题**

**1.** 选课库 school 中有成绩表 sc(sno, cno, grade) 和课程表 course(cno, cname)。写一条 SQL：查询每门课程成绩前 3 名的学生（学号、课程名、成绩、名次），并列时名次相同。

??? tip "答案与解析"
    **参考答案：**

    ```sql
    WITH r AS (
      SELECT sc.sno, c.cname, sc.grade,
             RANK() OVER (PARTITION BY sc.cno ORDER BY sc.grade DESC) AS rk
      FROM sc JOIN course c ON sc.cno = c.cno
    )
    SELECT sno, cname, grade, rk
    FROM r
    WHERE rk <= 3
    ORDER BY cname, rk;
    ```

    评分要点：用 RANK（并列同名次）；PARTITION BY 课程；名次筛选写在外层查询。

    考查：窗口函数 · 认知层次：应用 · [回看 11.5.2](#1152-row_numberrankdense_rank)
    { .quiz-meta }

**2.** 用 PyMySQL 写一个函数 `add_score(sno, cno, grade)`，向 sc 表插入一条成绩记录：要求使用参数化查询；插入成功提交，出错回滚并把错误继续抛出；连接最后一定关闭。可以使用本章的 `get_connection()`。

??? tip "答案与解析"
    **参考答案：**

    ```python
    from shopdb import get_connection     # 配置文件中的 database 改为 school

    def add_score(sno, cno, grade):
        conn = get_connection()
        try:
            with conn.cursor() as cur:
                cur.execute("INSERT INTO sc (sno, cno, grade) VALUES (%s, %s, %s)",
                            (sno, cno, grade))
            conn.commit()
        except Exception:
            conn.rollback()
            raise
        finally:
            conn.close()
    ```

    评分要点：%s 占位且不加引号；commit 和 rollback 位置正确；finally 中关闭连接。

    考查：程序中的事务 · 认知层次：应用 · [回看 11.3.3](#1133)
    { .quiz-meta }
