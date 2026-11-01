"""生成“社区小店”示例数据库（教材编写，全部内容为虚构）。

用法（在 labs/ 目录下）：python data/make_shop_db.py
输出：
    data/shop_mysql.sql      MySQL 8.4 建库建表 + 数据（第 3 章起使用）
    data/shop_postgres.sql   PostgreSQL 建表 + 数据（第 10、12 章）
    data/shop.sqlite         SQLite 版（网页“试一试”同一份数据）
    data/csv/*.csv           八张表的 CSV（第 3 章导入练习）
固定随机种子，重复运行结果相同。人名为随机组合，手机号以 100 开头（不存在的号段）。
"""
import csv
import random
import sqlite3
from datetime import date, datetime, timedelta
from decimal import Decimal
from pathlib import Path

random.seed(2026)
HERE = Path(__file__).resolve().parent

CATEGORIES = ["粮油米面", "早餐冲饮", "休闲零食", "饮料", "乳制品", "生鲜果蔬", "调味品", "日用百货"]

SUPPLIERS = [  # 名称, 联系人, 城市
    ("禾丰粮油批发部", "陈建国", "广州"), ("晨光食品贸易公司", "李秀英", "广州"), ("南粤乳业配送站", "黄志明", "佛山"),
    ("岭南果蔬合作社", "梁桂芳", "广州"), ("百味调料行", "周海涛", "东莞"), ("洁家日用品商行", "吴丽娟", "广州"),
    ("开心零食供应链", "郑伟", "深圳"), ("清泉饮品经销部", "何晓燕", "广州"),
]

# 名称, 类别序号(1起), 供应商序号, 售价, 进价, 单位, 描述（第 12 章语义搜索用）
PRODUCTS = [
    ("东北大米 5kg", 1, 1, "39.90", "31.00", "袋", "东北产粳米，米粒饱满，蒸出来软糯有米香，适合全家日常主食"),
    ("泰国香米 2.5kg", 1, 1, "32.80", "25.50", "袋", "长粒香米，饭粒松散带清香，适合炒饭和配咖喱"),
    ("花生油 5L", 1, 1, "89.00", "72.00", "桶", "压榨一级花生油，香味浓，适合炒菜和凉拌"),
    ("菜籽油 5L", 1, 1, "65.00", "52.00", "桶", "非转基因菜籽油，烟点高，适合煎炸"),
    ("挂面 1kg", 1, 1, "8.50", "6.00", "包", "细圆挂面，煮五分钟即可，口感爽滑，做汤面拌面都行"),
    ("全麦面粉 2.5kg", 1, 1, "22.00", "16.80", "袋", "含麦麸的全麦粉，适合做馒头、饺子皮和全麦面包"),
    ("小米 1kg", 1, 4, "15.80", "11.50", "袋", "黄小米，熬粥绵软易消化，适合老人和小孩做早餐"),
    ("燕麦片 1kg", 2, 2, "26.90", "19.00", "袋", "无蔗糖纯燕麦片，开水冲泡三分钟就软，膳食纤维高，早餐饱腹"),
    ("即食豆浆粉 30 包", 2, 2, "29.90", "21.00", "盒", "独立小包装，热水一冲即可，豆香浓，早上赶时间的好帮手"),
    ("芝麻糊 600g", 2, 2, "18.80", "13.20", "罐", "黑芝麻糊，温水冲调，细腻顺滑，老人家早餐常备"),
    ("速溶咖啡 40 条", 2, 2, "45.00", "33.00", "盒", "三合一速溶咖啡，提神醒脑，适合上班族"),
    ("全麦面包 400g", 2, 2, "12.90", "8.60", "袋", "切片全麦面包，松软低油，可直接吃或烤一下配煎蛋"),
    ("鲜肉包 6 个", 2, 2, "15.00", "10.50", "袋", "速冻鲜肉包，蒸十分钟即可，皮软馅多，早餐方便"),
    ("原味薯片 104g", 3, 7, "8.90", "5.80", "罐", "罐装原味薯片，香脆咸香，看剧追球的零食"),
    ("每日坚果 25g×30", 3, 7, "99.00", "72.00", "盒", "混合坚果独立小包，核桃腰果蔓越莓，办公室健康零食"),
    ("苏打饼干 400g", 3, 7, "13.50", "9.20", "盒", "咸味苏打饼干，口感酥脆不甜腻，胃不舒服时也能吃一点"),
    ("牛肉干 100g", 3, 7, "35.00", "25.00", "袋", "五香牛肉干，有嚼劲，适合户外和旅行带着吃"),
    ("话梅 150g", 3, 7, "9.90", "6.30", "袋", "酸甜话梅，开胃解馋，坐车时含一颗不晕"),
    ("海苔 40g", 3, 7, "16.80", "11.50", "盒", "原味烤海苔，薄脆低热量，小朋友爱吃"),
    ("矿泉水 550ml×24", 4, 8, "28.00", "20.00", "箱", "天然矿泉水整箱装，家庭和办公饮用"),
    ("可乐 330ml×6", 4, 8, "15.90", "11.40", "组", "经典可乐六连罐，冰镇后口感更好"),
    ("无糖绿茶 500ml", 4, 8, "4.50", "3.00", "瓶", "无糖茶饮料，清爽解腻，控糖人群可选"),
    ("橙汁 1L", 4, 8, "13.80", "9.80", "瓶", "100% 橙汁，不加糖，补充维生素 C"),
    ("凉茶 310ml×12", 4, 8, "36.00", "26.00", "箱", "广式凉茶，清热下火，吃火锅烧烤时配着喝"),
    ("纯牛奶 250ml×16", 5, 3, "52.00", "40.00", "箱", "全脂纯牛奶，蛋白质 3.2g，早餐配面包或燕麦"),
    ("低脂牛奶 1L", 5, 3, "15.50", "11.00", "盒", "低脂鲜牛奶，需冷藏，适合控制体重的人"),
    ("原味酸奶 100g×8", 5, 3, "19.90", "14.00", "组", "原味发酵酸奶，帮助消化，冷藏保存"),
    ("儿童奶酪棒 20 支", 5, 3, "39.90", "28.50", "袋", "高钙奶酪棒，软软的好入口，适合小朋友加餐"),
    ("鸡蛋 30 枚", 6, 4, "26.00", "20.50", "盒", "农家鲜鸡蛋，蛋黄饱满，煮蒸煎炒都合适"),
    ("西红柿 500g", 6, 4, "5.80", "3.90", "份", "沙瓤西红柿，酸甜多汁，做番茄炒蛋或番茄汤"),
    ("香蕉 1kg", 6, 4, "9.90", "6.80", "份", "熟透软糯的香蕉，老人小孩都好咀嚼，补充钾"),
    ("苹果 1kg", 6, 4, "12.80", "9.00", "份", "红富士苹果，脆甜多汁，每天一个"),
    ("生菜 300g", 6, 4, "4.50", "2.80", "份", "新鲜生菜，可涮火锅、做沙拉、夹汉堡"),
    ("土豆 1kg", 6, 4, "6.50", "4.20", "份", "黄心土豆，炖煮软糯，做土豆丝也爽口"),
    ("豆腐 400g", 6, 4, "4.00", "2.60", "盒", "嫩豆腐，口感滑嫩易咀嚼，适合老人，做汤或红烧"),
    ("生抽 500ml", 7, 5, "12.90", "8.90", "瓶", "酿造生抽，颜色浅味道鲜，炒菜凉拌提鲜"),
    ("老抽 500ml", 7, 5, "13.90", "9.50", "瓶", "红烧上色用老抽，颜色红亮"),
    ("米醋 500ml", 7, 5, "8.80", "6.00", "瓶", "粮食酿造米醋，酸味柔和，凉拌和蘸饺子"),
    ("食盐 400g", 7, 5, "3.50", "2.20", "包", "加碘精制食盐"),
    ("蚝油 700g", 7, 5, "16.50", "11.80", "瓶", "鲜味浓郁的蚝油，炒青菜、焖鸡翅提鲜"),
    ("火锅底料 200g", 7, 5, "19.90", "13.50", "袋", "牛油麻辣火锅底料，一袋够三四个人吃"),
    ("抽纸 3 层×10 包", 8, 6, "25.90", "18.50", "提", "原生木浆抽纸，柔软有韧性"),
    ("洗洁精 1.5kg", 8, 6, "14.90", "10.20", "瓶", "去油洗洁精，不伤手，可洗果蔬"),
    ("洗衣液 3kg", 8, 6, "45.90", "33.00", "瓶", "低泡洗衣液，机洗手洗都可以，留香持久"),
    ("垃圾袋 100 只", 8, 6, "9.90", "6.50", "卷", "加厚垃圾袋，不易破"),
    ("牙膏 120g", 8, 6, "15.80", "10.90", "支", "含氟防蛀牙膏，清新口气"),
    ("五号电池 8 节", 8, 6, "19.80", "13.00", "板", "碱性五号电池，遥控器、玩具用"),
    ("保鲜膜 30m", 8, 6, "12.50", "8.20", "卷", "PE 保鲜膜，可微波加热，冰箱存剩菜"),
]

SURNAMES = list("王李张刘陈杨黄赵吴周徐孙马朱胡郭何林罗高梁郑谢宋唐许韩冯邓曹彭曾萧田潘袁蔡蒋")
GIVEN = list("伟芳娜敏静丽强磊军洋勇艳杰娟涛明超秀霞平刚桂英华玉兰梅琳斌浩宇欣怡子轩雨萱建国志红晓燕")
DISTRICTS = ["幸福里", "和平路", "东风社区", "滨江花园", "学府小区"]
POSITIONS = [("店长", None), ("副店长", 1), ("收银员", 2), ("收银员", 2), ("理货员", 2), ("理货员", 2), ("会计", 1), ("配送员", 2)]


def rand_name():
    n = random.choice(SURNAMES) + random.choice(GIVEN)
    if random.random() < 0.6:
        n += random.choice(GIVEN)
    return n


def rand_phone(used):
    while True:
        p = "100" + "".join(random.choice("0123456789") for _ in range(8))
        if p not in used:
            used.add(p)
            return p


def build():
    used = set()
    data = {}
    data["category"] = [(i + 1, n) for i, n in enumerate(CATEGORIES)]
    data["supplier"] = [(i + 1, n, c, rand_phone(used), city) for i, (n, c, city) in enumerate(SUPPLIERS)]
    prods = []
    for i, (n, cat, sup, price, cost, unit, desc) in enumerate(PRODUCTS):
        stock = random.choice([0, 3, 5, 8]) if i % 9 == 4 else random.randint(12, 120)
        shelf = date(2025, 1, 1) + timedelta(days=random.randint(0, 200))
        prods.append((i + 1, n, cat, sup, price, cost, stock, unit, desc, shelf.isoformat()))
    data["product"] = prods

    emps = []
    for i, (pos, mgr) in enumerate(POSITIONS):
        hire = date(2019, 3, 1) + timedelta(days=random.randint(0, 2000)) if i else date(2018, 6, 1)
        salary = {"店长": 9000, "副店长": 7200, "会计": 6500}.get(pos, random.choice([4800, 5000, 5200, 5500]))
        emps.append((i + 1, rand_name(), pos, mgr, hire.isoformat(), f"{salary}.00"))
    data["employee"] = emps

    custs = []
    for i in range(200):
        g = random.choice(["男", "女"])
        reg = date(2025, 1, 1) + timedelta(days=random.randint(0, 520))
        phone = rand_phone(used) if random.random() > 0.05 else None
        custs.append((i + 1, rand_name(), g, phone, random.choice(DISTRICTS), random.randint(1950, 2004), reg.isoformat()))
    data["customer"] = custs

    members = []
    mid = 1
    for c in custs:
        if random.random() < 0.55:
            jd = date.fromisoformat(c[6]) + timedelta(days=random.randint(0, 30))
            members.append([mid, c[0], "普通", 0, min(jd, date(2026, 6, 30)).isoformat()])
            mid += 1

    # 订单：2025-01-01 至 2026-06-30，约 2400 单；周末多、早晚高峰多
    orders, items = [], []
    start = datetime(2025, 1, 1)
    oid = 1
    weights = [3 if p[2] in (1, 2, 5, 6) else 2 for p in prods]
    active = [c for c in custs if random.random() < 0.85]
    for day in range(546):
        d = start + timedelta(days=day)
        n = random.randint(3, 5) + (2 if d.weekday() >= 5 else 0)
        for _ in range(n):
            hour = random.choice([7, 7, 8, 8, 9, 11, 12, 17, 18, 18, 19, 20, 21])
            t = d.replace(hour=hour, minute=random.randint(0, 59), second=random.randint(0, 59))
            if t.date() < date(2025, 1, 1):
                continue
            cand = [c for c in active if date.fromisoformat(c[6]) <= t.date()]
            cust = random.choice(cand)[0] if cand and random.random() < 0.8 else None
            emp = random.choice([3, 4]) if random.random() < 0.9 else random.choice([1, 2])
            pay = random.choices(["微信", "支付宝", "现金", "银行卡"], [55, 30, 10, 5])[0]
            status = "已退款" if random.random() < 0.02 else "已完成"
            orders.append((oid, cust, emp, t.strftime("%Y-%m-%d %H:%M:%S"), pay, status))
            k = random.choices([1, 2, 3, 4, 5], [30, 30, 20, 12, 8])[0]
            for pid in sorted(set(random.choices(range(1, len(prods) + 1), weights, k=k))):
                q = random.choices([1, 2, 3], [70, 22, 8])[0]
                items.append((oid, pid, q, prods[pid - 1][4]))
            oid += 1
    data["orders"] = orders
    data["order_item"] = items

    # 会员积分 = 会员加入后的消费额取整；等级按积分
    spend = {}
    by_order = {o[0]: o for o in orders}
    member_of = {m[1]: m for m in members}
    for o_id, pid, q, up in items:
        o = by_order[o_id]
        if o[1] in member_of and o[5] == "已完成" and o[3][:10] >= member_of[o[1]][4]:
            spend[o[1]] = spend.get(o[1], Decimal(0)) + Decimal(up) * q
    for m in members:
        m[3] = int(spend.get(m[1], 0))
        m[2] = "金卡" if m[3] >= 1500 else ("银卡" if m[3] >= 600 else "普通")
    data["member"] = [tuple(m) for m in members]
    return data


COLUMNS = {
    "category": ["category_id", "name"],
    "supplier": ["supplier_id", "name", "contact", "phone", "city"],
    "product": ["product_id", "name", "category_id", "supplier_id", "price", "cost", "stock", "unit", "description", "shelf_date"],
    "employee": ["employee_id", "name", "position", "manager_id", "hire_date", "salary"],
    "customer": ["customer_id", "name", "gender", "phone", "district", "birth_year", "reg_date"],
    "member": ["member_id", "customer_id", "level", "points", "join_date"],
    "orders": ["order_id", "customer_id", "employee_id", "order_time", "pay_method", "status"],
    "order_item": ["order_id", "product_id", "quantity", "unit_price"],
}

MYSQL_DDL = """-- 社区小店示例数据库（MySQL 8.4）。教材编写，内容为虚构。
DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE shop;

CREATE TABLE category (
  category_id INT PRIMARY KEY,
  name        VARCHAR(20) NOT NULL UNIQUE
);
CREATE TABLE supplier (
  supplier_id INT PRIMARY KEY,
  name        VARCHAR(40) NOT NULL,
  contact     VARCHAR(20),
  phone       CHAR(11),
  city        VARCHAR(20)
);
CREATE TABLE product (
  product_id  INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(40) NOT NULL,
  category_id INT NOT NULL,
  supplier_id INT,
  price       DECIMAL(8,2) NOT NULL CHECK (price > 0),
  cost        DECIMAL(8,2),
  stock       INT NOT NULL DEFAULT 0,
  unit        VARCHAR(10),
  description VARCHAR(200),
  shelf_date  DATE,
  FOREIGN KEY (category_id) REFERENCES category(category_id),
  FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);
CREATE TABLE employee (
  employee_id INT PRIMARY KEY,
  name        VARCHAR(20) NOT NULL,
  position    VARCHAR(20) NOT NULL,
  manager_id  INT,
  hire_date   DATE,
  salary      DECIMAL(8,2),
  FOREIGN KEY (manager_id) REFERENCES employee(employee_id)
);
CREATE TABLE customer (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  name        VARCHAR(20) NOT NULL,
  gender      ENUM('男','女'),
  phone       CHAR(11) UNIQUE,
  district    VARCHAR(20),
  birth_year  SMALLINT,
  reg_date    DATE NOT NULL
);
CREATE TABLE member (
  member_id   INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL UNIQUE,
  level       VARCHAR(10) NOT NULL DEFAULT '普通',
  points      INT NOT NULL DEFAULT 0,
  join_date   DATE NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
CREATE TABLE orders (
  order_id    INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  employee_id INT NOT NULL,
  order_time  DATETIME NOT NULL,
  pay_method  VARCHAR(10),
  status      VARCHAR(10) NOT NULL DEFAULT '已完成',
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
  FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);
CREATE TABLE order_item (
  order_id    INT,
  product_id  INT,
  quantity    INT NOT NULL CHECK (quantity > 0),
  unit_price  DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES product(product_id)
);
"""


def pg_ddl():
    s = MYSQL_DDL.replace("(MySQL 8.4)", "(PostgreSQL)")
    s = s.split("USE shop;\n", 1)[1]
    s = "-- 社区小店示例数据库（PostgreSQL）。教材编写，内容为虚构。\n" + "DROP TABLE IF EXISTS order_item, orders, member, customer, employee, product, supplier, category CASCADE;\n" + s
    s = s.replace("INT PRIMARY KEY AUTO_INCREMENT", "INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY")
    s = s.replace("ENUM('男','女')", "VARCHAR(2) CHECK (gender IN ('男','女'))")
    s = s.replace("DATETIME", "TIMESTAMP")
    return s


def sqlite_ddl():
    s = MYSQL_DDL.split("USE shop;\n", 1)[1]
    s = s.replace(" AUTO_INCREMENT", "")
    s = s.replace("ENUM('男','女')", "TEXT CHECK (gender IN ('男','女'))")
    return s


def lit(v):
    if v is None:
        return "NULL"
    if isinstance(v, int):
        return str(v)
    return "'" + str(v).replace("'", "''") + "'"


def inserts(data, batch=500):
    out = []
    for t, cols in COLUMNS.items():
        rows = data[t]
        for i in range(0, len(rows), batch):
            vals = ",\n".join("(" + ",".join(lit(v) for v in r) + ")" for r in rows[i:i + batch])
            out.append(f"INSERT INTO {t} ({', '.join(cols)}) VALUES\n{vals};")
    return "\n".join(out) + "\n"


def main():
    data = build()
    ins = inserts(data)
    (HERE / "shop_mysql.sql").write_text(MYSQL_DDL + "\n" + ins, encoding="utf-8")
    pg_tail = "\n".join(f"SELECT setval(pg_get_serial_sequence('{t}', '{c}'), (SELECT MAX({c}) FROM {t}));"
                        for t, c in [("product", "product_id"), ("customer", "customer_id"), ("member", "member_id"), ("orders", "order_id")])
    (HERE / "shop_postgres.sql").write_text(pg_ddl() + "\n" + ins + pg_tail + "\n", encoding="utf-8")
    db = HERE / "shop.sqlite"
    db.unlink(missing_ok=True)
    con = sqlite3.connect(db)
    con.executescript("PRAGMA foreign_keys=ON;\n" + sqlite_ddl() + ins)
    con.commit()
    con.execute("VACUUM")
    con.close()
    (HERE / "csv").mkdir(exist_ok=True)
    for t, cols in COLUMNS.items():
        with open(HERE / "csv" / f"{t}.csv", "w", newline="", encoding="utf-8") as f:
            w = csv.writer(f)
            w.writerow(cols)
            w.writerows(["" if v is None else v for v in r] for r in data[t])
    print({t: len(r) for t, r in data.items()})


if __name__ == "__main__":
    main()
