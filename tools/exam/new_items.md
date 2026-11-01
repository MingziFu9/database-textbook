# 模拟卷新编题目（由 make_mock_exam.py 拼进附录 F，不单独发布）

<!-- intro -->
---
title: 附录 F 期末闭卷模拟卷
description: 按期末闭卷考试的题型和分值组成的两套模拟卷，含选择、判断、填空、SQL 编写、数据库设计和简答，可以直接作答并查看解析
---

# 附录 F 期末闭卷模拟卷

本课程期末为**闭卷笔试**。下面两套模拟卷按期末考试的题型和分值组成，覆盖全书 12 章。选择、判断和简答题从各章课后练习中抽取；填空、SQL 编写和数据库设计题为新编题目，SQL 题的参考答案都在小店示例库 shop 上实际运行过，解析里给出了运行结果，方便你上机核对。

| 题型 | 题数 | 分值 | 合计 |
|---|---|---|---|
| 单项选择题 | 20 | 每题 1 分 | 20 |
| 多项选择题 | 5 | 每题 2 分 | 10 |
| 判断题 | 10 | 每题 1 分 | 10 |
| 填空题 | 10 空 | 每空 1 分 | 10 |
| SQL 编写题 | 5 | 每题 4 分 | 20 |
| 数据库设计题 | 1 | 12 分 | 12 |
| 简答题 | 3 | 每题 6 分 | 18 |
| **合计** | | | **100** |

建议限时 100 分钟，**不看书、不上机**，在纸上独立做完一整套，再展开“答案与解析”核对。SQL 题写完后，可以到 MySQL 或网页“试一试”框里运行一遍，看结果是否和解析一致。选择题和判断题可以直接点击作答；每道题解析下方的“回看”链接可以跳回对应章节复习。

!!! tip "闭卷复习建议"
    重点记牢：关系模型的术语和三类完整性；SQL 四类语句和常用数据类型；单表查询的子句顺序（书写顺序和执行顺序）、聚合函数与 GROUP BY / HAVING；内连接、左连接和子查询的写法；E-R 图三种联系转关系模式的规则；函数依赖和 1NF、2NF、3NF 的判断与拆分；视图和索引的作用与代价；事务的 ACID、三种并发问题和四种隔离级别；GRANT / REVOKE、mysqldump 备份恢复；参数化查询防注入；向量相似度和 RAG 的流程。各章“本章小结”和[学习图谱](../learning-graph/index.md)可以帮你串起全书。

**SQL 编写题使用的表**（小店示例库 shop 的一部分，下划线表示主键）：

| 表 | 列 |
|---|---|
| category（类别） | <u>category_id</u> 类别编号，name 类别名 |
| product（商品） | <u>product_id</u> 商品编号，name 商品名，category_id 类别编号（外键），price 售价，stock 库存 |
| customer（顾客） | <u>customer_id</u> 顾客编号，name 姓名，gender 性别，phone 手机号，district 所在小区 |
| orders（订单） | <u>order_id</u> 订单号，customer_id 顾客编号（外键，散客为 NULL），order_time 下单时间，pay_method 付款方式，status 状态（已完成 / 已退款） |
| order_item（订单明细） | <u>order_id, product_id</u>，quantity 数量，unit_price 成交单价 |
<!-- end -->

<!-- p1-fill -->
**四、填空题**（每空 1 分，共 10 分）

**1.** 关系表中能唯一标识每一行、由设计者选定的候选键叫作＿＿＿＿。

**2.** 删除整张表（连同表结构）用 ＿＿＿＿ TABLE；只清空全部数据、保留表结构用 ＿＿＿＿ TABLE。

**3.** LIKE 模糊查询中，通配符 ＿＿＿＿ 表示任意多个字符，＿＿＿＿ 表示恰好一个字符。

**4.** 对 GROUP BY 分组后的结果再按条件筛选，要用 ＿＿＿＿ 子句。

**5.** 事务的四个特性简称 ＿＿＿＿，其中 I 指的是 ＿＿＿＿。

**6.** MySQL 的 InnoDB 存储引擎默认的事务隔离级别是 ＿＿＿＿。

**7.** 给用户授予权限的 SQL 语句以关键字 ＿＿＿＿ 开头。

??? tip "答案与解析"
    1. 主键（主码）　[回看 2.3.1](../chapters/02-relational-model/index.md#231)
    2. DROP；TRUNCATE　[回看 3.5.3](../chapters/03-sql-ddl-dml/index.md#353-drop-truncate)
    3. `%`；`_`　[回看 4.2.2](../chapters/04-single-table-query/index.md#422-betweeninlike)
    4. HAVING　[回看 4.5.3](../chapters/04-single-table-query/index.md#453-having)
    5. ACID；隔离性（Isolation）　[回看 9.1.3](../chapters/09-transaction/index.md#913-acid)
    6. 可重复读（REPEATABLE READ）　[回看 9.2.2](../chapters/09-transaction/index.md#922)
    7. GRANT　[回看 10.4.2](../chapters/10-administration/index.md#1042-grant-revoke)
<!-- end -->

<!-- p1-sql -->
**五、SQL 编写题**（每题 4 分，共 20 分。使用卷首给出的表）

**1.** 查询售价在 10 元到 20 元之间（含 10 元和 20 元）的商品名称和售价，按售价从高到低排列。

??? tip "答案与解析"
    ```sql
    SELECT name, price
    FROM product
    WHERE price BETWEEN 10 AND 20
    ORDER BY price DESC;
    ```

    在 shop 库上运行得到 19 行，前三行是火锅底料 200g 19.90、原味酸奶 100g×8 19.90、五号电池 8 节 19.80。也可以写 `price >= 10 AND price <= 20`。

    评分要点：选对列 1 分；条件正确（含两端）2 分；排序 1 分。 · [回看 4.2.2](../chapters/04-single-table-query/index.md#422-betweeninlike)

**2.** 统计每个类别的商品种数和平均售价（保留两位小数），只显示商品种数不少于 6 种的类别，结果显示类别编号、种数、平均售价。

??? tip "答案与解析"
    ```sql
    SELECT category_id, COUNT(*) AS 种数, ROUND(AVG(price), 2) AS 平均售价
    FROM product
    GROUP BY category_id
    HAVING COUNT(*) >= 6;
    ```

    运行结果 6 行：类别 1（7 种，39.00）、2（6 种，24.75）、3（6 种，30.52）、6（7 种，9.93）、7（6 种，12.58）、8（7 种，20.67）。

    常见错误：把 `COUNT(*) >= 6` 写在 WHERE 里。WHERE 在分组之前执行，不能用聚合函数。

    评分要点：GROUP BY 1 分；两个聚合函数 1 分；HAVING 条件 2 分。 · [回看 4.5.3](../chapters/04-single-table-query/index.md#453-having)

**3.** 查询“乳制品”类别中所有商品的名称和库存（只知道类别名，不知道类别编号）。

??? tip "答案与解析"
    ```sql
    SELECT p.name, p.stock
    FROM product p
    JOIN category c ON p.category_id = c.category_id
    WHERE c.name = '乳制品';
    ```

    运行结果 4 行：纯牛奶 250ml×16 88、低脂牛奶 1L 114、原味酸奶 100g×8 74、儿童奶酪棒 20 支 37。也可以用子查询：`WHERE category_id = (SELECT category_id FROM category WHERE name = '乳制品')`。

    评分要点：连接条件（或子查询）2 分；WHERE 条件 1 分；选列 1 分。 · [回看 5.2.1](../chapters/05-multi-table-query/index.md#521)

**4.** 查询从来没有下过订单的顾客的编号和姓名。

??? tip "答案与解析"
    ```sql
    SELECT c.customer_id, c.name
    FROM customer c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_id IS NULL;
    ```

    运行结果 29 行（10 潘桂敏、17 徐怡洋、29 韩娜怡……）。

    也可以写成 `WHERE customer_id NOT IN (SELECT customer_id FROM orders WHERE customer_id IS NOT NULL)`。注意：orders 里散客订单的 customer_id 是 NULL，如果子查询里**不加** `WHERE customer_id IS NOT NULL`，NOT IN 一行也查不出来（编者实测结果为 0 行），因为“和 NULL 比较”的结果是未知。

    评分要点：左连接 2 分；`IS NULL` 判断 2 分（子查询写法正确同样给分，漏掉 NULL 处理扣 1 分）。 · [回看 5.3.2](../chapters/05-multi-table-query/index.md#532)

**5.** 创建视图 v_low_stock，显示库存少于 10 件的商品的编号、名称和库存。

??? tip "答案与解析"
    ```sql
    CREATE VIEW v_low_stock AS
    SELECT product_id, name, stock
    FROM product
    WHERE stock < 10;
    ```

    `SELECT * FROM v_low_stock;` 在 shop 库上得到 5 行：挂面 1kg 0、原味薯片 104g 8、橙汁 1L 0、苹果 1kg 8、火锅底料 200g 8。

    评分要点：CREATE VIEW … AS 2 分；查询正确 2 分。 · [回看 8.1.1](../chapters/08-view-index/index.md#811)
<!-- end -->

<!-- p1-design -->
**六、数据库设计题**（12 分）

小区快递驿站要建一个数据库，需求如下：

- 记录居民的编号、姓名、手机号、楼栋号；
- 记录每件快递的运单号、快递公司、到站时间、取件码、取件时间；
- 驿站有若干货架，记录货架号和位置（如“东墙第 2 排”）；
- 一件快递属于一位居民，一位居民可以有多件快递；一件快递放在一个货架上，一个货架上可以放多件快递。

（1）找出实体和联系，说明每个联系的类型，并写出每个实体的主码。（4 分）

（2）把 E-R 图转换成关系模式，标出主码和外码。（4 分）

（3）有人图省事，只建了一张表：快递信息（运单号，快递公司，居民编号，居民姓名，居民手机号，货架号，货架位置）。这张表最高满足第几范式？会出现什么问题？应怎样拆分？（4 分）

??? tip "答案与解析"
    （1）三个实体：居民（主码：居民编号）、快递（主码：运单号）、货架（主码：货架号）。两个联系：居民—快递“收件”，一对多（1:N）；货架—快递“存放”，一对多（1:N）。每找对一个实体或联系给 0.5～1 分。

    （2）一对多联系不单独建表，在“多”的一方（快递）加外码：

    - 居民（<u>居民编号</u>，姓名，手机号，楼栋号）
    - 货架（<u>货架号</u>，位置）
    - 快递（<u>运单号</u>，快递公司，到站时间，取件码，取件时间，居民编号，货架号），其中居民编号是外码，参照居民；货架号是外码，参照货架。

    （3）主码是运单号（单个属性），不存在部分依赖，满足 2NF；但存在传递依赖：运单号 → 居民编号 → 居民姓名、居民手机号；运单号 → 货架号 → 货架位置，所以**不满足 3NF，最高是 2NF**。问题：同一位居民的姓名、手机号随每件快递重复存储，换手机号要改很多行（更新异常）；没有快递的居民信息存不进去（插入异常）；取走某货架上唯一的快递并删除记录后，货架位置也丢了（删除异常）。拆分：把居民编号 → 姓名、手机号拆成居民表，货架号 → 位置拆成货架表，快递表只保留居民编号、货架号作为外码，结果就是第（2）问的三张表。

    评分要点：判断 2NF 并指出传递依赖 2 分；说出至少一种异常 1 分；拆分正确 1 分。 · [回看 6.4.1](../chapters/06-er-design/index.md#641) · [回看 7.3.3](../chapters/07-normalization/index.md#733-3nf)
<!-- end -->

<!-- p2-fill -->
**四、填空题**（每空 1 分，共 10 分）

**1.** 陈氏表示法的 E-R 图中，实体用 ＿＿＿＿ 表示，联系用 ＿＿＿＿ 表示。

**2.** 外键约束用来保证 ＿＿＿＿ 完整性。

**3.** 在 SELECT 语句前加上关键字 ＿＿＿＿，可以查看 MySQL 打算怎样执行这条查询（执行计划）。

**4.** 关系中每个属性的值都不可再分（一格只放一个值），称为满足第 ＿＿＿＿ 范式。

**5.** 统计行数的聚合函数是 ＿＿＿＿，求平均值的聚合函数是 ＿＿＿＿。

**6.** 撤销当前事务中所有还没提交的修改，用 ＿＿＿＿ 语句。

**7.** 用 mysqldump 导出的备份文件由 SQL 语句组成，这种备份属于 ＿＿＿＿ 备份（填“逻辑”或“物理”）。

**8.** 文本向量常用 ＿＿＿＿ 相似度来衡量两个向量的方向是否一致，值越接近 1 越相似。

??? tip "答案与解析"
    1. 矩形；菱形　[回看 6.3.3](../chapters/06-er-design/index.md#633-e-r)
    2. 参照　[回看 2.4.1](../chapters/02-relational-model/index.md#241)
    3. EXPLAIN　[回看 8.4.1](../chapters/08-view-index/index.md#841-explain)
    4. 一（1NF）　[回看 7.3.1](../chapters/07-normalization/index.md#731-1nf)
    5. COUNT；AVG　[回看 4.5.1](../chapters/04-single-table-query/index.md#451)
    6. ROLLBACK　[回看 9.1.1](../chapters/09-transaction/index.md#911)
    7. 逻辑　[回看 10.5.2](../chapters/10-administration/index.md#1052-mysqldump)
    8. 余弦　[回看 12.3.1](../chapters/12-vector-db/index.md#1231)
<!-- end -->

<!-- p2-sql -->
**五、SQL 编写题**（每题 4 分，共 20 分。使用卷首给出的表）

**1.** 查询姓“王”的顾客的姓名和所在小区。

??? tip "答案与解析"
    ```sql
    SELECT name, district
    FROM customer
    WHERE name LIKE '王%';
    ```

    运行结果 2 行：王芳 和平路、王宇怡 学府小区。

    评分要点：LIKE 1 分；`'王%'` 写对 2 分；选列 1 分。 · [回看 4.2.2](../chapters/04-single-table-query/index.md#422-betweeninlike)

**2.** 统计 2026 年 6 月每种付款方式的订单数，按订单数从多到少排列。

??? tip "答案与解析"
    ```sql
    SELECT pay_method, COUNT(*) AS 订单数
    FROM orders
    WHERE order_time >= '2026-06-01' AND order_time < '2026-07-01'
    GROUP BY pay_method
    ORDER BY 订单数 DESC;
    ```

    运行结果 4 行：微信 78、支付宝 40、银行卡 14、现金 9。

    时间条件也可以写 `YEAR(order_time) = 2026 AND MONTH(order_time) = 6`，结果相同，但对列用了函数，order_time 上的索引就用不上了（第 8 章）。注意不要写成 `BETWEEN '2026-06-01' AND '2026-06-30'`：order_time 带时分秒，6 月 30 日白天的订单会被漏掉。

    评分要点：时间条件 1 分；GROUP BY 和 COUNT 2 分；排序 1 分。 · [回看 4.5.2](../chapters/04-single-table-query/index.md#452-group-by)

**3.** 计算每个订单的金额（数量 × 成交单价之和），列出金额最高的 5 个订单的订单号和金额。

??? tip "答案与解析"
    ```sql
    SELECT order_id, SUM(quantity * unit_price) AS 金额
    FROM order_item
    GROUP BY order_id
    ORDER BY 金额 DESC
    LIMIT 5;
    ```

    运行结果：448 420.50、2406 414.70、1220 387.80、2165 374.00、1721 337.00。

    评分要点：SUM 表达式 1 分；按订单分组 1 分；排序 1 分；LIMIT 1 分。 · [回看 4.3.2](../chapters/04-single-table-query/index.md#432-limit)

**4.** 查询售价高于全部商品平均售价的商品的名称和售价。

??? tip "答案与解析"
    ```sql
    SELECT name, price
    FROM product
    WHERE price > (SELECT AVG(price) FROM product);
    ```

    全部商品的平均售价是 23.33 元，运行结果 16 行（每日坚果 25g×30 99.00、花生油 5L 89.00……燕麦片 1kg 26.90、鸡蛋 30 枚 26.00、抽纸 3 层×10 包 25.90）。

    常见错误：写成 `WHERE price > AVG(price)`。WHERE 里不能直接用聚合函数，要先用子查询把平均值算出来。

    评分要点：子查询 2 分；比较条件 1 分；选列 1 分。 · [回看 5.5.1](../chapters/05-multi-table-query/index.md#551-where)

**5.** 小店要发优惠券。写出建表语句：表名 coupon，列有优惠券编号 coupon_id（整数，自动增长，主键）、顾客编号 customer_id（整数，不能为空，外键参照 customer 表）、面额 amount（最多 6 位、其中 2 位小数，不能为空，必须大于 0）、到期日 expire_date（日期）。

??? tip "答案与解析"
    ```sql
    CREATE TABLE coupon (
      coupon_id   INT PRIMARY KEY AUTO_INCREMENT,
      customer_id INT NOT NULL,
      amount      DECIMAL(6,2) NOT NULL CHECK (amount > 0),
      expire_date DATE,
      FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
    );
    ```

    编者在 MySQL 8.4 上执行成功，`SHOW CREATE TABLE coupon` 显示主键、外键 `coupon_ibfk_1` 和检查约束 `coupon_chk_1` 都已建立。

    评分要点：主键与自动增长 1 分；DECIMAL(6,2) 与 NOT NULL 1 分；CHECK 约束 1 分；外键 1 分。 · [回看 3.4.2](../chapters/03-sql-ddl-dml/index.md#342)
<!-- end -->

<!-- p2-design -->
**六、数据库设计题**（12 分）

一家社区培训学校要管理报名信息：

- 学员有学员号、姓名、电话；
- 课程有课程号、课程名、学费；
- 教师有工号、姓名；
- 一位学员可以报多门课程，一门课程有多位学员报名，报名时要记下报名日期和结课成绩；
- 一门课程只由一位教师上，一位教师可以上多门课程。

（1）找出实体和联系，说明联系的类型；指出哪个联系带有属性。（4 分）

（2）把 E-R 图转换成关系模式，标出主码和外码。（4 分）

（3）有人建了这样一张报名表：报名（学员号，课程号，学员姓名，课程名，报名日期，成绩），主码是（学员号，课程号）。这张表最高满足第几范式？为什么？应怎样拆分？（4 分）

??? tip "答案与解析"
    （1）三个实体：学员、课程、教师。两个联系：学员—课程“报名”，多对多（M:N），带属性报名日期、成绩；教师—课程“授课”，一对多（1:N）。

    （2）多对多联系单独建表，主码由两端实体的主码组成；一对多联系在“多”的一方加外码：

    - 学员（<u>学员号</u>，姓名，电话）
    - 教师（<u>工号</u>，姓名）
    - 课程（<u>课程号</u>，课程名，学费，工号），工号是外码，参照教师
    - 报名（<u>学员号，课程号</u>，报名日期，成绩），学员号、课程号分别是外码，参照学员和课程

    （3）每个属性都不可再分，满足 1NF。但存在部分依赖：学员号 → 学员姓名，课程号 → 课程名，它们只依赖主码的一部分，所以**不满足 2NF，最高是 1NF**。拆分：把学员姓名移到学员表、课程名移到课程表，报名表只保留（学员号，课程号，报名日期，成绩），报名日期和成绩完全依赖于整个主码。拆分后满足 3NF。

    评分要点：判断 1NF 并指出部分依赖 2 分；拆分正确 2 分。 · [回看 6.4.1](../chapters/06-er-design/index.md#641) · [回看 7.3.2](../chapters/07-normalization/index.md#732-2nf)
<!-- end -->
