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

## 模拟卷一 { #paper1 }

**一、单项选择题**（每题 1 分，共 20 分）

<div class="quiz" data-answer="C" markdown>

**1.** 数据库系统（DBS）、数据库（DB）和数据库管理系统（DBMS）三者之间的关系是（　　）。

- A. DB 包括 DBS 和 DBMS
- B. DBMS 包括 DB 和 DBS
- C. DBS 包括 DB 和 DBMS
- D. 三者互不包含

</div>

??? tip "答案与解析"
    **答案：C**

    解析：数据库系统是由数据库、数据库管理系统、应用程序、管理员和用户组成的整体，所以它包含 DB 和 DBMS。这是历年等级考试的高频题。

    考查：DB、DBMS、DBS 的关系 · 认知层次：记忆 · [回看 1.1.2](../chapters/01-overview/index.md#112)
    { .quiz-meta }

<div class="quiz" data-answer="C" markdown>

**2.** 关系模型的三个组成部分是（　　）。

- A. 表、行、列
- B. 主键、外键、索引
- C. 数据结构、关系操作、完整性约束
- D. 外模式、模式、内模式

</div>

??? tip "答案与解析"
    **答案：C**

    解析：D 是第 1 章的三级模式，不要混淆。

    考查：关系模型三要素 · 认知层次：记忆 · [回看 2.1.2](../chapters/02-relational-model/index.md#212)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**3.** 下列 SQL 语句中，属于数据定义语言（DDL）的是（　　）。

- A. CREATE TABLE
- B. INSERT
- C. SELECT
- D. GRANT

</div>

??? tip "答案与解析"
    **答案：A**

    解析：INSERT 是 DML，SELECT 是 DQL，GRANT 是 DCL。

    考查：SQL 语句分类 · 认知层次：记忆 · [回看 3.1.2](../chapters/03-sql-ddl-dml/index.md#312-sql)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**4.** 在 utf8mb4 字符集下，`VARCHAR(20)` 的列最多能存（　　）。

- A. 20 个字节
- B. 6 个汉字
- C. 10 个汉字
- D. 20 个汉字

</div>

??? tip "答案与解析"
    **答案：D**

    解析：VARCHAR(n) 的 n 是字符数，一个汉字是一个字符（占 3 个字节）。

    考查：字符串类型 · 认知层次：理解 · [回看 3.3.2](../chapters/03-sql-ddl-dml/index.md#332)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**5.** 要去掉查询结果中的重复行，应在 SELECT 后使用关键字（　　）。

- A. UNIQUE
- B. DISTINCT
- C. DIFFERENT
- D. GROUP

</div>

??? tip "答案与解析"
    **答案：B**

    解析：UNIQUE 是建表时的唯一约束，不是查询关键字。

    考查：DISTINCT · 认知层次：记忆 · [回看 4.1.3](../chapters/04-single-table-query/index.md#413-distinct)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**6.** 商品列表每页显示 10 条，要取第 3 页，应写（　　）。

- A. `LIMIT 3, 10`
- B. `LIMIT 20, 10`
- C. `LIMIT 30, 10`
- D. `LIMIT 10, 3`

</div>

??? tip "答案与解析"
    **答案：B**

    解析：第 k 页跳过 (k−1)×n 行，即跳过 20 行、取 10 行。

    考查：分页 · 认知层次：应用 · [回看 4.3.2](../chapters/04-single-table-query/index.md#432-limit)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**7.** 要列出所有顾客及其订单，没有订单的顾客也要显示，应使用（　　）。

- A. `customer c JOIN orders o ON …`
- B. `customer c LEFT JOIN orders o ON …`
- C. `customer c RIGHT JOIN orders o ON …`
- D. `customer c, orders o`

</div>

??? tip "答案与解析"
    **答案：B**

    解析：左外连接保留左表（顾客）的全部行。C 保留的是订单表的全部行。

    考查：左外连接 · 认知层次：应用 · [回看 5.3.2](../chapters/05-multi-table-query/index.md#532)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**8.** 写在 FROM 后面的子查询（派生表）必须（　　）。

- A. 只返回一个值
- B. 起别名
- C. 使用 EXISTS
- D. 使用 UNION

</div>

??? tip "答案与解析"
    **答案：B**

    解析：否则报错 Every derived table must have its own alias。

    考查：派生表 · 认知层次：记忆 · [回看 5.5.3](../chapters/05-multi-table-query/index.md#553-from)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**9.** 一个班级有多名学生，一名学生只属于一个班级。班级和学生之间是（　　）联系。

- A. 1 : N
- B. 1 : 1
- C. M : N
- D. N : 1 且 M : N

</div>

??? tip "答案与解析"
    **答案：A**

    解析：从两头各问一遍：一个班级对应多名学生，一名学生对应一个班级，是一对多。

    考查：联系类型 · 认知层次：应用 · [回看 6.3.2](../chapters/06-er-design/index.md#632)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**10.** “知道了学号，就能唯一确定姓名”，记作（　　）。

- A. 学号 → 姓名
- B. 姓名 → 学号
- C. 学号 ← → 姓名
- D. (学号, 姓名) → 学号

</div>

??? tip "答案与解析"
    **答案：A**

    解析：箭头从决定因素指向被决定的属性。

    考查：函数依赖 · 认知层次：记忆 · [回看 7.2.1](../chapters/07-normalization/index.md#721-a-b)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**11.** 关于视图，下列说法正确的是（　　）。

- A. 视图中保存了一份数据的副本
- B. 视图是保存起来的查询，本身不存储数据
- C. 删除视图会删除基本表中的数据
- D. 视图只能来自一张表

</div>

??? tip "答案与解析"
    **答案：B**

    解析：视图是虚表，数据每次从基本表现查；删除视图只删定义；视图可以来自多张表的连接。

    考查：视图的概念 · 认知层次：理解 · [回看 8.1.1](../chapters/08-view-index/index.md#811)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**12.** 表上有组合索引 (a, b, c)，下列条件中不能有效利用该索引的是（　　）。

- A. `WHERE a = 1`
- B. `WHERE b = 2 AND c = 3`
- C. `WHERE a = 1 AND b = 2`
- D. `WHERE a = 1 AND b = 2 AND c = 3`

</div>

??? tip "答案与解析"
    **答案：B**

    解析：B 跳过了最左边的列 a，违反最左前缀原则。

    考查：最左前缀 · 认知层次：应用 · [回看 8.3.2](../chapters/08-view-index/index.md#832)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**13.** 事务中的操作要么全部完成，要么全部不做，这是事务的（　　）。

- A. 原子性
- B. 一致性
- C. 隔离性
- D. 持久性

</div>

??? tip "答案与解析"
    **答案：A**

    考查：ACID · 认知层次：记忆 · [回看 9.1.3](../chapters/09-transaction/index.md#913-acid)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**14.** MySQL InnoDB 默认的事务隔离级别是（　　）。

- A. READ UNCOMMITTED
- B. READ COMMITTED
- C. SERIALIZABLE
- D. REPEATABLE READ

</div>

??? tip "答案与解析"
    **答案：D**

    考查：隔离级别 · 认知层次：记忆 · [回看 9.2.2](../chapters/09-transaction/index.md#922)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**15.** 修改了 MySQL 的配置文件 my.ini 后，要让新设置生效，需要（　　）。

- A. 执行 COMMIT
- B. 重启 MySQL 服务
- C. 重新建库
- D. 执行 FLUSH TABLES

</div>

??? tip "答案与解析"
    **答案：B**

    配置文件只在服务启动时读取，改完要重启服务，再用 SHOW VARIABLES 确认。

    考查：配置文件 · 认知层次：记忆 · [回看 10.1.2](../chapters/10-administration/index.md#1012-myini)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**16.** 把一组权限打包，再整体授予多个账号，使用的是（　　）。

- A. 视图
- B. 角色
- C. 触发器
- D. 存储过程

</div>

??? tip "答案与解析"
    **答案：B**

    考查：角色 · 认知层次：记忆 · [回看 10.4.3](../chapters/10-administration/index.md#1043)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**17.** 用 Python 程序访问数据库，正确的步骤顺序是（　　）。

- A. 游标 → 连接 → 执行 → 取结果 → 关闭
- B. 连接 → 游标 → 执行 → 取结果 → 关闭
- C. 执行 → 连接 → 游标 → 关闭 → 取结果
- D. 连接 → 执行 → 关闭 → 游标 → 取结果

</div>

??? tip "答案与解析"
    **答案：B**

    考查：访问数据库的步骤 · 认知层次：记忆 · [回看 11.1.1](../chapters/11-python-app/index.md#1111)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**18.** 把数据库口令写在配置文件里而不是代码里，主要目的是（　　）。

- A. 让程序运行更快
- B. 避免口令随代码泄露，并且改口令时不用改代码
- C. 让数据库不需要口令
- D. 防止 SQL 注入

</div>

??? tip "答案与解析"
    **答案：B**

    考查：连接配置 · 认知层次：理解 · [回看 11.3.1](../chapters/11-python-app/index.md#1131)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**19.** 顾客搜索“适合老人吃的软一点的早餐”，用 `LIKE '%适合老人吃的软一点的早餐%'` 查不到任何商品，根本原因是（　　）。

- A. 数据库没有建索引
- B. 关键词搜索按字面匹配，不理解意思
- C. 商品表的数据太少
- D. 没有使用 ORDER BY

</div>

??? tip "答案与解析"
    **答案：B**

    考查：关键词搜索的局限 · 认知层次：理解 · [回看 12.1](../chapters/12-vector-db/index.md#121)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**20.** 向量 a = [1, 0] 和 b = [0, 1] 的余弦相似度是（　　）。

- A. 1
- B. −1
- C. 0.5
- D. 0

</div>

??? tip "答案与解析"
    **答案：D**

    内积 1×0 + 0×1 = 0，所以余弦相似度为 0：两个向量互相垂直，方向完全不同。

    考查：余弦相似度 · 认知层次：应用 · [回看 12.3.1](../chapters/12-vector-db/index.md#1231)
    { .quiz-meta }

**二、多项选择题**（每题 2 分，共 10 分。多选、少选、错选均不得分）

<div class="quiz quiz-multi" data-answer="ACD" markdown>

**1.** 关于关系的性质，下列说法正确的有（　　）。

- A. 每个分量都必须是不可再分的值
- B. 行的顺序不同，就是不同的关系
- C. 任意两行不能完全相同
- D. 同一个关系中，列名不能重复

</div>

??? tip "答案与解析"
    **答案：ACD**

    解析：行的顺序和列的顺序都无关紧要，交换后还是同一个关系，所以 B 错。

    考查：关系的性质 · 认知层次：理解 · [回看 2.2.2](../chapters/02-relational-model/index.md#222)
    { .quiz-meta }

<div class="quiz quiz-multi" data-answer="ABD" markdown>

**2.** 下列条件中，与 `category_id IN (4, 5)` 结果相同的有（　　）。

- A. `category_id = 4 OR category_id = 5`
- B. `category_id BETWEEN 4 AND 5`（category_id 为整数）
- C. `category_id = 4 AND category_id = 5`
- D. `NOT (category_id <> 4 AND category_id <> 5)`

</div>

??? tip "答案与解析"
    **答案：ABD**

    解析：C 要求同时等于 4 和 5，不可能成立。D 是“不是（既不等于 4 也不等于 5）”，等于“等于 4 或等于 5”。B 对整数而言只有 4、5 两个值。

    考查：IN 与逻辑运算 · 认知层次：分析 · [回看 4.2.4](../chapters/04-single-table-query/index.md#424-andornot)
    { .quiz-meta }

<div class="quiz quiz-multi" data-answer="ACD" markdown>

**3.** 关于子查询，下列说法正确的有（　　）。

- A. 子查询必须用括号括起来
- B. 写在 SELECT 中的子查询可以返回多行
- C. 相关子查询用到了主查询中的列
- D. EXISTS 只关心子查询有没有返回行

</div>

??? tip "答案与解析"
    **答案：ACD**

    解析：SELECT 中的子查询作为一列，只能返回一个值。

    考查：子查询 · 认知层次：理解 · [回看 5.5](../chapters/05-multi-table-query/index.md#55)
    { .quiz-meta }

<div class="quiz quiz-multi" data-answer="ABC" markdown>

**4.** 视图的作用有（　　）。

- A. 简化复杂的查询
- B. 只向某些用户提供部分列或行，保护数据
- C. 基本表结构变化时，保持对外提供的数据格式不变
- D. 提高所有查询的速度

</div>

??? tip "答案与解析"
    **答案：ABC**

    解析：视图每次都要执行背后的查询，不会自动让查询变快。

    考查：视图的用途 · 认知层次：理解 · [回看 8.1.2](../chapters/08-view-index/index.md#812)
    { .quiz-meta }

<div class="quiz quiz-multi" data-answer="ABC" markdown>

**5.** 下列关于 MySQL 事务的说法，正确的有（　　）。

- A. 默认处于自动提交模式，每条语句执行完立即提交
- B. 事务中某条语句出错后，需要显式执行 ROLLBACK 才会撤销整个事务
- C. DROP TABLE 等 DDL 语句会自动提交当前事务
- D. 提交后的事务仍然可以用 ROLLBACK 撤销

</div>

??? tip "答案与解析"
    **答案：ABC**

    解析：提交后修改已永久保存，不能再回滚（持久性）。

    考查：事务控制 · 认知层次：理解 · [回看 9.1.2](../chapters/09-transaction/index.md#912)
    { .quiz-meta }

**三、判断题**（每题 1 分，共 10 分）

<div class="quiz quiz-judge" data-answer="×" markdown>

**1.** 一个数据库可以有多个模式和多个内模式。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：×**

    解析：一个数据库只有一个模式和一个内模式，但可以有多个外模式。

    考查：三级模式 · 认知层次：记忆 · [回看 1.2.2](../chapters/01-overview/index.md#122)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="√" markdown>

**2.** 关系模式是对关系结构的描述，相对固定；关系是某一时刻表中的数据，会随时变化。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：√**

    考查：关系与关系模式 · 认知层次：理解 · [回看 2.2.1](../chapters/02-relational-model/index.md#221)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="×" markdown>

**3.** MySQL 中，存中文时字符集选 `utf8` 和 `utf8mb4` 完全一样。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：×**

    解析：MySQL 的 `utf8` 是残缺版（utf8mb3），存不了表情符号和部分生僻字，应使用 utf8mb4。

    考查：字符集 · 认知层次：记忆 · [回看 3.2.1](../chapters/03-sql-ddl-dml/index.md#321-create-database)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="√" markdown>

**4.** 在 WHERE 条件中，AND 的优先级高于 OR。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：√**

    解析：所以 AND、OR 混用时应加括号明确意思。

    考查：逻辑运算优先级 · 认知层次：记忆 · [回看 4.2.4](../chapters/04-single-table-query/index.md#424-andornot)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="√" markdown>

**5.** `A LEFT JOIN B` 和 `B RIGHT JOIN A` 的结果相同。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：√**

    考查：左右外连接 · 认知层次：理解 · [回看 5.3.2](../chapters/05-multi-table-query/index.md#532)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="√" markdown>

**6.** 联系也可以有自己的属性。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：√**

    解析：如“订单包含商品”的数量、“业主拥有房屋”的产权份额。

    考查：联系 · 认知层次：理解 · [回看 6.3.2](../chapters/06-er-design/index.md#632)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="√" markdown>

**7.** 满足第三范式的关系一定满足第二范式。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：√**

    解析：高一级范式满足低一级范式的所有要求。

    考查：范式的关系 · 认知层次：记忆 · [回看 7.3](../chapters/07-normalization/index.md#73)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="√" markdown>

**8.** 基本表的数据修改后，通过视图查询看到的数据会随之变化。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：√**

    考查：视图的概念 · 认知层次：理解 · [回看 8.1.1](../chapters/08-view-index/index.md#811)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="×" markdown>

**9.** 在 MySQL 中，事务里有一条语句执行出错时，整个事务会自动回滚。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：×**

    解析：只是出错的那条语句失败，前面的修改仍在事务中，需要显式 ROLLBACK。

    考查：回滚 · 认知层次：理解 · [回看 9.1.1](../chapters/09-transaction/index.md#911)
    { .quiz-meta }

<div class="quiz" data-answer="A" data-judge markdown>

**10.** MySQL 可以把权限细化到某张表的某几列。

- A. 正确
- B. 错误

</div>

??? tip "答案与解析"
    **答案：正确**

    例如 `GRANT SELECT (customer_id, name) ON shop.customer TO …`。

    考查：列级权限 · 认知层次：记忆 · [回看 10.4.2](../chapters/10-administration/index.md#1042-grant-revoke)
    { .quiz-meta }

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

**七、简答题**（每题 6 分，共 18 分）

**1.** 什么是插入异常、删除异常和更新异常？各举一个小店的例子。

??? tip "答案与解析"
    **参考答案：** 插入异常：想记录一条信息，却因缺少别的信息而无法插入，如新商品没人买过，没有订单号，放不进订单大表。删除异常：删除数据时把不该删的信息也删了，如删掉唯一一张买过生抽的订单，“生抽属于调味品”的信息也没了。更新异常：同一信息存了多处，修改时漏改造成不一致，如顾客换了电话，大表中只改了一行，同一顾客出现两个电话。

    考查：三种异常 · 认知层次：理解 · [回看 7.1.2](../chapters/07-normalization/index.md#712)
    { .quiz-meta }

**2.** 说明四种隔离级别分别能防止哪些并发问题。

??? tip "答案与解析"
    **参考答案：** READ UNCOMMITTED 不能防止脏读、不可重复读和幻读；READ COMMITTED 能防止脏读；REPEATABLE READ 能防止脏读和不可重复读（MySQL InnoDB 在此级别下通过快照和间隙锁，大多数情况下也不会出现幻读），是 MySQL 默认级别；SERIALIZABLE 三种问题都能防止，但并发性能最差。

    考查：隔离级别 · 认知层次：理解 · [回看 9.2.2](../chapters/09-transaction/index.md#922)
    { .quiz-meta }

**3.** 用自己的话说明：向量数据库为什么能“按意思”找到内容？它和关系数据库在查询结果上最大的区别是什么？

??? tip "答案与解析"
    **参考答案：**内容先由嵌入模型转换成向量，嵌入模型在训练中学会了让意思相近的内容得到相近的向量；查询时把问题也转换成向量，找出距离最近（相似度最高）的向量，对应的内容就是意思最接近的。最大区别：关系数据库的查询结果是精确、确定的，满足条件的行一行不多一行不少；向量数据库返回的是“最相似的 K 个”，结果是近似的，即使都不相关也会返回，需要设相似度门槛。

    考查：向量搜索原理 · 认知层次：理解 · [回看 12.2](../chapters/12-vector-db/index.md#122)
    { .quiz-meta }


## 模拟卷二 { #paper2 }

**一、单项选择题**（每题 1 分，共 20 分）

<div class="quiz" data-answer="D" markdown>

**1.** 下列关于数据库特点的说法，错误的是（　　）。

- A. 数据长期存储在计算机中
- B. 数据按一定的结构组织
- C. 数据可以被多个用户、多个程序共享
- D. 每个应用程序都要有一份自己的数据副本

</div>

??? tip "答案与解析"
    **答案：D**

    解析：“每个程序一份数据”正是文件系统和人工管理阶段的缺点，数据库的特点是共享、冗余小。

    考查：数据库的特点 · 认知层次：理解 · [回看 1.1.1](../chapters/01-overview/index.md#111)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**2.** 订单明细表 order_item（订单号，商品号，数量，成交单价）中，一笔订单可以买多种商品，一种商品可以出现在多笔订单中。它的主键应该是（　　）。

- A. 订单号
- B. 商品号
- C. 数量
- D. {订单号，商品号}

</div>

??? tip "答案与解析"
    **答案：D**

    解析：单独的订单号、商品号都会重复，两者合起来才唯一，是复合主键。

    考查：复合主键 · 认知层次：应用 · [回看 2.3.1](../chapters/02-relational-model/index.md#231)
    { .quiz-meta }

<div class="quiz" data-answer="C" markdown>

**3.** 关于主键约束和唯一约束，下列说法正确的是（　　）。

- A. 一张表可以有多个主键
- B. 唯一约束的列不允许为空
- C. 一张表可以有多个唯一约束
- D. 主键的值可以为空

</div>

??? tip "答案与解析"
    **答案：C**

    解析：一张表只有一个主键，主键不能为空；唯一约束可以有多个，并且允许为空。

    考查：主键与唯一约束 · 认知层次：理解 · [回看 3.4.2](../chapters/03-sql-ddl-dml/index.md#342)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**4.** 要删除商品表中的全部数据但保留表结构，且让自增编号从 1 重新开始，应使用（　　）。

- A. DROP TABLE product;
- B. DELETE FROM product;
- C. ALTER TABLE product DROP;
- D. TRUNCATE TABLE product;

</div>

??? tip "答案与解析"
    **答案：D**

    解析：DROP 连表结构一起删；DELETE 删数据但自增编号接着原来的。另外，被外键引用的表不能 TRUNCATE。

    考查：DROP、TRUNCATE、DELETE · 认知层次：理解 · [回看 3.5.3](../chapters/03-sql-ddl-dml/index.md#353-drop-truncate)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**5.** 查询没有留手机号的顾客，正确的条件是（　　）。

- A. `phone = NULL`
- B. `phone = ''`
- C. `phone = 0`
- D. `phone IS NULL`

</div>

??? tip "答案与解析"
    **答案：D**

    解析：和 NULL 用 `=` 比较的结果是 NULL，选不出任何行；判断空值只能用 IS NULL。

    考查：IS NULL · 认知层次：理解 · [回看 4.2.3](../chapters/04-single-table-query/index.md#423-is-null)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**6.** 下列哪个子句中可以使用聚合函数作为筛选条件（　　）。

- A. FROM
- B. WHERE
- C. GROUP BY
- D. HAVING

</div>

??? tip "答案与解析"
    **答案：D**

    解析：WHERE 在分组之前执行，不能用聚合函数；HAVING 在分组之后筛选，可以用。

    考查：HAVING · 认知层次：理解 · [回看 4.5.3](../chapters/04-single-table-query/index.md#453-having)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**7.** 查询员工姓名及其上级姓名，需要用到（　　）。

- A. 自连接
- B. 笛卡尔积
- C. UNION
- D. 派生表

</div>

??? tip "答案与解析"
    **答案：A**

    解析：上级也在员工表里，要把员工表和自己连接，起两个别名。

    考查：自连接 · 认知层次：理解 · [回看 5.4](../chapters/05-multi-table-query/index.md#54)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**8.** 关于 UNION 和 UNION ALL，正确的是（　　）。

- A. UNION 去掉重复行，UNION ALL 保留重复行
- B. UNION ALL 去掉重复行，UNION 保留重复行
- C. 两者都去掉重复行
- D. 两者合并的查询列数可以不同

</div>

??? tip "答案与解析"
    **答案：A**

    解析：合并的两个查询列数必须相同。

    考查：UNION · 认知层次：记忆 · [回看 5.6](../chapters/05-multi-table-query/index.md#56-union)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**9.** 部门 1 : N 员工，转换成关系模式时，外键应该（　　）。

- A. 加在部门表，参照员工表
- B. 加在员工表，参照部门表
- C. 两张表都加
- D. 新建一张中间表

</div>

??? tip "答案与解析"
    **答案：B**

    解析：1 : N 联系在“多”的一方（员工）加外键。

    考查：转换规则 · 认知层次：应用 · [回看 6.4.1](../chapters/06-er-design/index.md#641)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**10.** 第 5 题中的 E 要分解到 3NF，正确的是（　　）。

- A. E1(**工号**, 姓名, 部门号)，E2(**部门号**, 部门名称)
- B. E1(**工号**, 姓名)，E2(**部门号**, 部门名称)
- C. E1(**工号**, 姓名, 部门名称)，E2(**部门号**, 部门名称)
- D. E1(**工号**, 部门号, 部门名称)，E2(**工号**, 姓名)

</div>

??? tip "答案与解析"
    **答案：A**

    解析：B 丢掉了员工和部门的联系，拼不回去；C 用部门名称连接也不对，且 E1 仍有冗余；D 中 E1 仍有传递依赖。

    考查：分解 · 认知层次：应用 · [回看 7.3.4](../chapters/07-normalization/index.md#734)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**11.** MySQL InnoDB 存储引擎的索引使用的数据结构是（　　）。

- A. B+ 树
- B. 二叉树
- C. 链表
- D. 栈

</div>

??? tip "答案与解析"
    **答案：A**

    考查：B+ 树 · 认知层次：记忆 · [回看 8.2.2](../chapters/08-view-index/index.md#822-b)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**12.** InnoDB 中，叶子节点存放整行数据的索引是（　　）。

- A. 聚簇索引（主键索引）
- B. 唯一索引
- C. 普通二级索引
- D. 组合索引

</div>

??? tip "答案与解析"
    **答案：A**

    解析：二级索引的叶子只存索引列的值和主键。

    考查：聚簇索引 · 认知层次：理解 · [回看 8.2.3](../chapters/08-view-index/index.md#823)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**13.** 调用存储过程使用的语句是（　　）。

- A. CALL
- B. EXECUTE
- C. RUN
- D. SELECT

</div>

??? tip "答案与解析"
    **答案：A**

    解析：存储函数可以写在 SELECT 中，存储过程用 CALL 调用。

    考查：存储过程 · 认知层次：记忆 · [回看 9.4.1](../chapters/09-transaction/index.md#941-sql)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**14.** 在 mysql 命令行中创建存储过程前，通常要先执行 `DELIMITER //`，原因是（　　）。

- A. 存储过程名必须以 // 结尾
- B. 提高执行速度
- C. 开启事务
- D. 避免过程体中的分号被当作整条语句的结束

</div>

??? tip "答案与解析"
    **答案：D**

    考查：DELIMITER · 认知层次：理解 · [回看 9.4.1](../chapters/09-transaction/index.md#941-sql)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**15.** 要把查询 student 表的权限授予用户 'teacher'@'%'，正确的语句是（　　）。

- A. `GRANT SELECT ON school.student TO 'teacher'@'%';`
- B. `GRANT 'teacher'@'%' TO SELECT ON school.student;`
- C. `REVOKE SELECT ON school.student TO 'teacher'@'%';`
- D. `CREATE USER SELECT ON school.student;`

</div>

??? tip "答案与解析"
    **答案：A**

    格式是 `GRANT 权限 ON 对象 TO 账号`。REVOKE 是收回权限，而且要用 FROM。

    考查：GRANT 语法 · 认知层次：应用 · [回看 10.4.2](../chapters/10-administration/index.md#1042-grant-revoke)
    { .quiz-meta }

<div class="quiz" data-answer="D" markdown>

**16.** 某系统每天 23:00 做一次全量备份，并开启了二进制日志。第二天 15:00 发生误删，要把数据恢复到误删前，正确的做法是（　　）。

- A. 只导入前一天 23:00 的全量备份
- B. 只重放二进制日志
- C. 重新建库，手工录入当天数据
- D. 先导入全量备份，再重放二进制日志中备份之后、误删之前的操作

</div>

??? tip "答案与解析"
    **答案：D**

    只导入全量备份会丢失当天 23:00 以后到 15:00 之间的数据；这就是时间点恢复。

    考查：时间点恢复 · 认知层次：应用 · [回看 10.5.3](../chapters/10-administration/index.md#1053)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**17.** 下列 PyMySQL 写法中，能够防止 SQL 注入的是（　　）。

- A. `cur.execute("SELECT * FROM student WHERE sno = %s", (sno,))`
- B. `cur.execute("SELECT * FROM student WHERE sno = '" + sno + "'")`
- C. `cur.execute("SELECT * FROM student WHERE sno = '%s'" % sno)`
- D. `cur.execute(f"SELECT * FROM student WHERE sno = '{sno}'")`

</div>

??? tip "答案与解析"
    **答案：A**

    B、C、D 都是先由 Python 把输入拼进字符串，再交给数据库，都会被注入。只有 A 把 SQL 和参数分开传给 execute。

    考查：参数化查询 · 认知层次：应用 · [回看 11.2.2](../chapters/11-python-app/index.md#1122)
    { .quiz-meta }

<div class="quiz" data-answer="A" markdown>

**18.** 在窗口函数中，`PARTITION BY` 的作用是（　　）。

- A. 把行分成若干组，每组单独计算，但不合并行
- B. 把每组合并成一行
- C. 对结果排序
- D. 筛选满足条件的行

</div>

??? tip "答案与解析"
    **答案：A**

    这正是窗口函数与 GROUP BY 的区别。

    考查：窗口函数 · 认知层次：理解 · [回看 11.5.1](../chapters/11-python-app/index.md#1151-group-by)
    { .quiz-meta }

<div class="quiz" data-answer="C" markdown>

**19.** 关于近似最近邻（ANN）搜索，下列说法正确的是（　　）。

- A. 结果一定和逐个比较完全相同
- B. 比逐个比较更慢，但更准
- C. 以少量准确性为代价，大幅提高查询速度
- D. 只能用于关系数据库

</div>

??? tip "答案与解析"
    **答案：C**

    考查：近似最近邻 · 认知层次：理解 · [回看 12.4.2](../chapters/12-vector-db/index.md#1242)
    { .quiz-meta }

<div class="quiz" data-answer="B" markdown>

**20.** 在 pgvector 中，表示余弦距离的运算符是（　　）。

- A. `<->`
- B. `<=>`
- C. `<#>`
- D. `LIKE`

</div>

??? tip "答案与解析"
    **答案：B**

    `<->` 是欧氏距离，`<#>` 是负内积。

    考查：pgvector · 认知层次：记忆 · [回看 12.5.3](../chapters/12-vector-db/index.md#1253-pgvector)
    { .quiz-meta }

**二、多项选择题**（每题 2 分，共 10 分。多选、少选、错选均不得分）

<div class="quiz quiz-multi" data-answer="ABC" markdown>

**1.** 关于外键的参照动作，下列说法正确的有（　　）。

- A. 默认情况下，删除仍被引用的行会被拒绝
- B. ON DELETE CASCADE 会把引用它的行一起删除
- C. ON DELETE SET NULL 会把引用它的外键改为 NULL
- D. 外键列不能为空

</div>

??? tip "答案与解析"
    **答案：ABC**

    解析：外键列可以为空（散客订单的顾客编号就是空），除非另加 NOT NULL。

    考查：参照动作 · 认知层次：理解 · [回看 3.4.4](../chapters/03-sql-ddl-dml/index.md#344)
    { .quiz-meta }

<div class="quiz quiz-multi" data-answer="ACD" markdown>

**2.** 下列属于多对多联系的有（　　）。

- A. 订单与商品
- B. 顾客与会员卡（一人最多办一张）
- C. 学生与课程
- D. 业主与房屋（一套房可以有共同业主）

</div>

??? tip "答案与解析"
    **答案：ACD**

    解析：B 是一对一。

    考查：联系类型 · 认知层次：分析 · [回看 6.3.2](../chapters/06-er-design/index.md#632)
    { .quiz-meta }

<div class="quiz quiz-multi" data-answer="AC" markdown>

**3.** 关系 R(**学号, 课程号**, 姓名, 成绩)，学号 → 姓名，(学号, 课程号) → 成绩。下列说法正确的有（　　）。

- A. 学号和课程号是主属性
- B. R 满足 2NF
- C. 姓名部分依赖于码
- D. 成绩部分依赖于码

</div>

??? tip "答案与解析"
    **答案：AC**

    解析：姓名只依赖于学号，是部分依赖，所以 R 不满足 2NF；成绩要学号和课程号一起才能确定，是完全依赖。

    考查：部分依赖与 2NF · 认知层次：分析 · [回看 7.3.2](../chapters/07-normalization/index.md#732-2nf)
    { .quiz-meta }

<div class="quiz" data-answer="ABD" data-multi markdown>

**4.** 下列做法中，符合最小权限原则的有（　　）。

- A. 收银员只授予查商品、录订单的权限
- B. 报表程序使用只读账号连接数据库
- C. 为了方便，所有员工共用 root 账号
- D. 员工离职当天锁定其账号

</div>

??? tip "答案与解析"
    **答案：ABD**

    共用 root 既违反最小权限原则，也无法追查是谁做的操作。

    考查：最小权限原则 · 认知层次：应用 · [回看 10.4.4](../chapters/10-administration/index.md#1044)
    { .quiz-meta }

<div class="quiz" data-answer="ABD" data-multi markdown>

**5.** 在程序中实现下单事务时，下列做法正确的有（　　）。

- A. 所有步骤都成功后再调用 commit
- B. 出现异常时调用 rollback
- C. 每执行一条 SQL 就 commit 一次
- D. 读库存时用 SELECT … FOR UPDATE 加锁

</div>

??? tip "答案与解析"
    **答案：ABD**

    每条都 commit 就失去了事务“要么全做要么全不做”的作用。

    考查：程序中的事务 · 认知层次：应用 · [回看 11.3.3](../chapters/11-python-app/index.md#1133)
    { .quiz-meta }

**三、判断题**（每题 1 分，共 10 分）

<div class="quiz quiz-judge" data-answer="×" markdown>

**1.** 删除了自增编号为 3 的行后，下一次插入的行会重新使用编号 3。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：×**

    解析：自增编号只增不减，删除的号不会再用。

    考查：AUTO_INCREMENT · 认知层次：理解 · [回看 3.6.3](../chapters/03-sql-ddl-dml/index.md#363-delete)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="√" markdown>

**2.** CASE WHEN 表达式中，前面的条件成立后，后面的条件不再判断。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：√**

    解析：所以挂面库存为 0 时显示“缺货”而不是“库存紧张”，条件的先后顺序很重要。

    考查：CASE 表达式 · 认知层次：理解 · [回看 4.4.4](../chapters/04-single-table-query/index.md#444-if-case)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="×" markdown>

**3.** 外连接时，右表的筛选条件写在 ON 里和写在 WHERE 里，结果总是一样的。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：×**

    解析：写在 WHERE 里会把右边为 NULL 的行筛掉，外连接退化为内连接。

    考查：ON 与 WHERE · 认知层次：分析 · [回看 5.3.4](../chapters/05-multi-table-query/index.md#534-on-where)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="√" markdown>

**4.** 员工表中 manager_id 参照本表的 employee_id，这表示的是实体自身的一对多联系。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：√**

    考查：自身联系 · 认知层次：理解 · [回看 6.4.1](../chapters/06-er-design/index.md#641)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="×" markdown>

**5.** 满足第三范式的关系一定满足 BC 范式。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：×**

    解析：反过来才成立。如选课表 sct(学生, 课程, 教师) 是 3NF 但不是 BCNF。

    考查：BC 范式 · 认知层次：理解 · [回看 7.4](../chapters/07-normalization/index.md#74-bc)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="×" markdown>

**6.** 定义外键时，MySQL 不会为外键列建立索引，需要手动创建。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：×**

    解析：InnoDB 会自动为外键列建索引（如果还没有可用的索引）。

    考查：索引种类 · 认知层次：记忆 · [回看 8.3.1](../chapters/08-view-index/index.md#831)
    { .quiz-meta }

<div class="quiz quiz-judge" data-answer="√" markdown>

**7.** 一条 UPDATE 语句修改了 5 行，FOR EACH ROW 的触发器会执行 5 次。

- √ 正确
- × 错误

</div>

??? tip "答案与解析"
    **答案：√**

    解析：实验 9-3 中饮料九折时记了 5 条日志。

    考查：触发器 · 认知层次：理解 · [回看 9.5.1](../chapters/09-transaction/index.md#951)
    { .quiz-meta }

<div class="quiz" data-answer="A" data-judge markdown>

**8.** 在 PostgreSQL 中，`SELECT 7 / 2;` 的结果是 3。

- A. 正确
- B. 错误

</div>

??? tip "答案与解析"
    **答案：正确**

    两个整数相除是整数除法；MySQL 中同样的语句结果是 3.5000。

    考查：SQL 写法差异 · 认知层次：记忆 · [回看 10.2.4](../chapters/10-administration/index.md#1024-sql)
    { .quiz-meta }

<div class="quiz" data-answer="B" data-judge markdown>

**9.** 只要把 SQL 字符串和参数用 `%` 运算符拼在一起，例如 `cur.execute(sql % (sno,))`，就属于参数化查询。

- A. 正确
- B. 错误

</div>

??? tip "答案与解析"
    **答案：错误**

    `sql % (sno,)` 是 Python 的字符串格式化，在交给 execute 之前已经拼好了，仍会被注入。

    考查：参数化查询 · 认知层次：理解 · [回看 11.2.2](../chapters/11-python-app/index.md#1122)
    { .quiz-meta }

<div class="quiz" data-answer="A" data-judge markdown>

**10.** 向量长度都为 1 时，两个向量的内积等于它们的余弦相似度。

- A. 正确
- B. 错误

</div>

??? tip "答案与解析"
    **答案：正确**

    余弦相似度 = 内积 ÷ (长度 × 长度)，长度都为 1 时分母为 1。

    考查：内积与余弦 · 认知层次：理解 · [回看 12.3.1](../chapters/12-vector-db/index.md#1231)
    { .quiz-meta }

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

**七、简答题**（每题 6 分，共 18 分）

**1.** 为什么不把所有信息放在一张大表里，而要拆成多张表？拆开后怎么得到完整信息？

??? tip "答案与解析"
    **参考答案：** 一张大表会大量重复存储同样的信息（如顾客电话、商品类别），改一处要改很多行，容易改漏造成不一致，也浪费空间。拆成多张表后每条信息只存一次，表之间用外键联系；需要完整信息时，用连接运算按外键把表拼回来。

    考查：外键与连接 · 认知层次：理解 · [回看 2.3.2](../chapters/02-relational-model/index.md#232)
    { .quiz-meta }

**2.** 用“书的目录”比喻说明索引为什么能加快查询，并说明索引的代价。

??? tip "答案与解析"
    **参考答案：** 没有索引时，查找一个值只能从第一行看到最后一行（全表扫描），就像一页页翻书。索引把某列的值排好序并记下每个值所在行的位置，就像书后的索引按拼音排好、注明页码，查找时先查目录再直接翻到那一页，只要看很少的行。代价：索引要占额外的存储空间；每次插入、修改、删除数据，索引也要同步调整，降低写入速度；建索引本身也要花时间。

    考查：索引原理 · 认知层次：理解 · [回看 8.2.1](../chapters/08-view-index/index.md#821)
    { .quiz-meta }

**3.** 用户在登录框的用户名处输入 `' OR '1'='1`，程序用拼接字符串的方式生成 `SELECT * FROM users WHERE username = '输入' AND …`。说明这会造成什么问题，以及从程序和数据库两方面怎样防范。

??? tip "答案与解析"
    **参考答案：**拼接后 WHERE 条件中出现 `OR '1'='1'`，条件恒为真，可能绕过登录验证或查出全部用户数据，这就是 SQL 注入。防范：程序方面使用参数化查询，用户输入只作为值传给数据库，不参与拼接 SQL；对输入长度、格式做检查。数据库方面，程序使用的账号遵守最小权限原则，只给必需的权限，口令只存哈希值，即使被注入，损失也有限。

    考查：SQL 注入 · 认知层次：分析 · [回看 10.6.1](../chapters/10-administration/index.md#1061-sql)
    { .quiz-meta }
