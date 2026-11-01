---
title: 附录 D 术语表
description: 本书主要术语的中英文名称、简明定义和例子，按章节顺序排列
---

# 附录 D 术语表

本表按章节顺序列出本书的主要术语，每个术语给出英文名称、简明定义和例子。正文中带虚线下划线的术语，把鼠标停在上面就能看到定义，点击可以跳到本表。

通用术语（如“过拟合”“精确率”）的译名和定义以本系列教材共用的《系列公共术语表》为准，各书保持一致。

## 第 1 章 数据库概述

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
| <span id="g-数据库"></span>数据库 | Database, DB | 长期存储在计算机内、有组织、可共享的大量数据的集合 | 社区小店的 shop 库，有商品、订单等 8 张表 |
| <span id="g-数据库管理系统"></span>数据库管理系统 | Database Management System, DBMS | 位于用户和操作系统之间、专门负责建立、使用和维护数据库的软件 | MySQL、PostgreSQL、达梦 |
| <span id="g-数据库系统"></span>数据库系统 | Database System, DBS | 由数据库、数据库管理系统、应用程序、数据库管理员和用户组成的整体 | 小店的 MySQL + 收银软件 + 管理员小林 + 店员 |
| <span id="g-外模式"></span>外模式 | External Schema | 某一类用户看到和使用的那部分数据的结构，也叫用户模式或子模式 | 收银员只看到商品名、价格和库存 |
| <span id="g-模式"></span>模式 | Schema | 数据库中全部数据的逻辑结构，包括有哪些表、表有哪些列、表之间的联系和约束 | shop 库的 8 张表及其列、类型、主外键 |
| <span id="g-内模式"></span>内模式 | Internal Schema | 数据在存储设备上的物理存储方式，如文件组织、索引和压缩方式，也叫存储模式 | 订单表按主键顺序存成 InnoDB 数据文件，另建了索引 |
| <span id="g-数据独立性"></span>数据独立性 | Data Independence | 应用程序不因数据的存储结构或逻辑结构改变而改变的特性，分物理独立性和逻辑独立性 | 加索引后收银软件不用改（物理独立性） |
| <span id="g-关系型数据库"></span>关系型数据库 | Relational Database | 用二维表（关系）组织数据、用 SQL 操作数据的数据库 | MySQL 里的 shop 库 |
| <span id="g-SQL"></span>SQL | Structured Query Language | 结构化查询语言，关系数据库的标准语言，用来定义、查询、修改数据和管理权限 | SELECT name, price FROM product; |
| <span id="g-MySQL"></span>MySQL | MySQL | 最流行的开源关系数据库管理系统之一，现由甲骨文公司维护 | 本课主线，版本 8.4 LTS |
| <span id="g-PostgreSQL"></span>PostgreSQL | PostgreSQL | 功能强大的开源关系数据库，扩展性好，支持 pgvector 等扩展 | 第 10 章对照学习，第 12 章配合 pgvector 存向量 |
| <span id="g-SQLite"></span>SQLite | SQLite | 嵌入在程序里的轻量级关系数据库，整个库就是一个文件，无需安装服务 | 本书网页“试一试”背后的数据库 |
| <span id="g-NoSQL"></span>NoSQL | NoSQL, Not Only SQL | 不采用（或不只采用）关系表模型的数据库的统称，常见的有键值、文档、列族、图四类 | Redis（键值）、MongoDB（文档）、Neo4j（图） |
| <span id="g-向量数据库"></span>向量数据库 | Vector Database | 专门存储向量并能快速找出与查询向量最相似的若干条记录的数据库 | Milvus、Chroma、pgvector |
| <span id="g-Text-to-SQL"></span>Text-to-SQL | Text-to-SQL, NL2SQL | 把自然语言问题自动翻译成 SQL 查询语句的技术，也叫 NL2SQL | “上个月卖得最好的 5 种商品”→ 一条 SELECT 语句 |

## 第 2 章 关系模型：用表格描述世界

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
| <span id="g-数据模型"></span>数据模型 | Data Model | 描述数据、数据之间的联系、数据操作和约束的一套概念和方法 | 层次模型、网状模型、关系模型 |
| <span id="g-关系模型"></span>关系模型 | Relational Model | 用二维表来表示实体和实体之间联系的数据模型，由关系数据结构、关系操作和完整性约束三部分组成 | 小店的数据全部存成 8 张二维表 |
| <span id="g-关系"></span>关系 | Relation | 一张满足一定条件的二维表 | 商品表 product |
| <span id="g-元组"></span>元组 | Tuple | 关系中的一行，表示一个具体的实体或一次联系 | 商品表中“燕麦片 1kg, 26.90, ……”这一行 |
| <span id="g-属性"></span>属性 | Attribute | 关系中的一列，每列有唯一的名字 | 商品表的 price 列 |
| <span id="g-域"></span>域 | Domain | 一个属性允许取值的范围 | 性别的域是 {男, 女} |
| <span id="g-关系模式"></span>关系模式 | Relation Schema | 对关系结构的描述，写成 关系名(属性1, 属性2, …) | 类别（类别编号，类别名称） |
| <span id="g-超键"></span>超键 | Super Key | 能唯一标识关系中每一行的一个或一组属性，可以含有多余的属性 | 顾客表的 {顾客编号, 姓名} |
| <span id="g-候选键"></span>候选键 | Candidate Key | 不含多余属性的超键，去掉其中任何一个属性就不能唯一标识一行 | 顾客表的 {顾客编号} 和 {手机号} |
| <span id="g-主键"></span>主键 | Primary Key | 从候选键中选定、用来唯一标识每一行的那个键，不能重复也不能为空 | customer_id；订单明细表的 {order_id, product_id} |
| <span id="g-外键"></span>外键 | Foreign Key | 一个表中引用另一个表主键的列，用来建立两张表之间的联系 | 订单表的 customer_id 引用顾客表 |
| <span id="g-完整性约束"></span>完整性约束 | Integrity Constraint | 数据库中的数据必须满足的规则，用来保证数据正确、有效、相容 | 主键非空、外键对得上、价格大于 0 |
| <span id="g-实体完整性"></span>实体完整性 | Entity Integrity | 主键的值不能为空，也不能重复 | 不能插入 category_id 为 NULL 的类别 |
| <span id="g-参照完整性"></span>参照完整性 | Referential Integrity | 外键的值要么为空，要么必须等于被参照表中某个主键的值 | 不能给不存在的 999 号顾客下单 |
| <span id="g-用户定义完整性"></span>用户定义完整性 | User-defined Integrity | 针对具体业务定义的约束，如非空、唯一、取值范围、默认值 | CHECK (price > 0) |
| <span id="g-关系代数"></span>关系代数 | Relational Algebra | 以关系为运算对象、运算结果也是关系的一组运算，包括选择、投影、连接、并、差等 | π_name(σ_price<5(product)) |
| <span id="g-选择"></span>选择 | Selection | 从关系中挑出满足条件的行，结果的列不变，记作 σ | σ_price<5(product) 选出 4 种商品 |
| <span id="g-投影"></span>投影 | Projection | 从关系中挑出指定的列，并去掉重复的行，记作 π | π_district(customer) 得到 5 个小区 |
| <span id="g-连接"></span>连接 | Join | 把两个关系按照某种条件拼接成一个新关系的运算，记作 ⋈ | 商品表与类别表按 category_id 连接 |

## 第 3 章 SQL 入门：建库、建表与增删改

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
| <span id="g-声明式语言"></span>声明式语言 | Declarative Language | 只描述想要什么结果、不描述具体执行步骤的编程语言，SQL 是典型代表 | SELECT name FROM product WHERE price < 5; 只说要什么 |
| <span id="g-DDL"></span>DDL | Data Definition Language | 数据定义语言，用来创建、修改、删除数据库对象，如 CREATE、ALTER、DROP | CREATE TABLE、ALTER TABLE、DROP TABLE |
| <span id="g-DML"></span>DML | Data Manipulation Language | 数据操纵语言，用来插入、修改、删除表中的数据，如 INSERT、UPDATE、DELETE | INSERT、UPDATE、DELETE |
| <span id="g-DQL"></span>DQL | Data Query Language | 数据查询语言，即 SELECT 语句，用来从表中查询数据 | SELECT * FROM product; |
| <span id="g-DCL"></span>DCL | Data Control Language | 数据控制语言，用来授予和收回权限，如 GRANT、REVOKE | GRANT SELECT ON myshop.* TO 'clerk'@'%'; |
| <span id="g-字符集"></span>字符集 | Character Set | 规定数据库用哪种编码存储文字，中文环境推荐 utf8mb4 | utf8mb4 能存中文和表情符号 |
| <span id="g-数据类型"></span>数据类型 | Data Type | 规定一列能存什么样的值以及占多大空间，如 INT、DECIMAL、VARCHAR、DATE | INT、DECIMAL(8,2)、VARCHAR(50)、DATE |
| <span id="g-非空约束"></span>非空约束 | NOT NULL Constraint | 规定某列不允许为空值，写作 NOT NULL | name VARCHAR(50) NOT NULL |
| <span id="g-唯一约束"></span>唯一约束 | UNIQUE Constraint | 规定某列（或几列组合）的值不能重复，写作 UNIQUE，允许有空值 | phone CHAR(11) UNIQUE |
| <span id="g-默认值"></span>默认值 | DEFAULT | 插入数据时没有给某列赋值，就自动填入的值，写作 DEFAULT | points INT DEFAULT 0 |
| <span id="g-检查约束"></span>检查约束 | CHECK Constraint | 规定某列的值必须满足的条件，写作 CHECK (条件)，MySQL 8.0.16 起生效 | CHECK (price > 0) |

## 第 4 章 单表查询与分组统计

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
| <span id="g-查询"></span>查询 | Query | 从数据库中按条件取出数据的操作，在 SQL 中用 SELECT 语句完成 | SELECT name, price FROM product; |
| <span id="g-别名"></span>别名 | Alias | 用 AS 给查询结果中的列（或表）另起的名字，只在这条语句里有效 | price - cost AS 毛利 |
| <span id="g-DISTINCT"></span>DISTINCT | DISTINCT | SELECT 中的关键字，去掉结果里完全相同的重复行 | SELECT DISTINCT district FROM customer; |
| <span id="g-通配符"></span>通配符 | Wildcard | LIKE 模式中代表任意字符的符号：% 代表任意多个字符（含 0 个），_ 代表恰好一个字符 | name LIKE '%奶%' |
| <span id="g-分页"></span>分页 | Pagination | 把很多行结果分成若干页逐页显示，MySQL 中用 LIMIT 跳过若干行再取若干行实现 | LIMIT 10, 5 取第 3 页（每页 5 行） |
| <span id="g-CASE-表达式"></span>CASE 表达式 | CASE Expression | 按条件从多个值中选一个的 SQL 表达式，CASE WHEN 条件 THEN 值 … ELSE 值 END | CASE WHEN stock = 0 THEN '缺货' ELSE '有货' END |
| <span id="g-聚合函数"></span>聚合函数 | Aggregate Function | 把多行数据汇总成一个值的函数，如 COUNT 计数、SUM 求和、AVG 平均、MAX 最大、MIN 最小 | COUNT(*)、SUM(stock)、AVG(price) |
| <span id="g-分组"></span>分组 | Grouping (GROUP BY) | 用 GROUP BY 把某列值相同的行归为一组，再对每组分别做聚合统计 | SELECT category_id, COUNT(*) FROM product GROUP BY category_id; |
| <span id="g-HAVING"></span>HAVING | HAVING Clause | GROUP BY 之后对分组进行筛选的子句，条件里可以使用聚合函数 | GROUP BY category_id HAVING COUNT(*) >= 7 |
| <span id="g-执行顺序"></span>执行顺序 | Logical Processing Order | SELECT 语句各子句被数据库处理的先后：FROM、WHERE、GROUP BY、HAVING、SELECT、ORDER BY、LIMIT | WHERE 先于 SELECT，所以 WHERE 里不能用别名 |

## 第 5 章 多表查询：连接与子查询

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
| <span id="g-笛卡尔积"></span>笛卡尔积 | Cartesian Product | 把第一张表的每一行和第二张表的每一行两两配对得到的结果，行数是两表行数的乘积 | 48 种商品 × 8 个类别 = 384 行 |
| <span id="g-表别名"></span>表别名 | Table Alias | 在 FROM 中给表起的简短名字，用来区分不同表里的同名列，如 product p | FROM product p JOIN category c |
| <span id="g-内连接"></span>内连接 | Inner Join | 只保留两张表中满足连接条件、能对得上的行的连接，用 INNER JOIN … ON 写 | product p JOIN category c ON c.category_id = p.category_id |
| <span id="g-外连接"></span>外连接 | Outer Join | 除了对得上的行，还保留某一张表中对不上的行、另一边填 NULL 的连接，分为左外连接、右外连接和全外连接 | customer c LEFT JOIN orders o ON o.customer_id = c.customer_id |
| <span id="g-自连接"></span>自连接 | Self Join | 一张表和它自己连接，要给同一张表起两个不同的别名，常用于员工和上级这类自己参照自己的情况 | employee e LEFT JOIN employee m ON m.employee_id = e.manager_id |
| <span id="g-子查询"></span>子查询 | Subquery | 嵌在另一条 SQL 语句里、用括号括起来的 SELECT，它的结果给外面的语句使用 | WHERE price > (SELECT AVG(price) FROM product) |
| <span id="g-EXISTS"></span>EXISTS | EXISTS | 判断子查询是否至少返回一行的运算符，返回了就为真，常和相关子查询一起用来查“有没有” | WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id) |
| <span id="g-相关子查询"></span>相关子查询 | Correlated Subquery | 用到了主查询中的列、要对主查询的每一行分别执行一次的子查询 | 比本类别平均价贵的商品 |
| <span id="g-派生表"></span>派生表 | Derived Table | 写在 FROM 中、把子查询的结果当作一张临时表来用的写法，必须起别名 | FROM (SELECT …) AS t |
| <span id="g-UNION"></span>UNION | UNION | 把两个 SELECT 的结果上下合并成一个结果的集合操作，UNION 去重，UNION ALL 不去重 | SELECT … UNION ALL SELECT … |
| <span id="g-公用表表达式"></span>公用表表达式 | Common Table Expression (CTE) | 用 WITH 名字 AS (子查询) 在语句开头先定义好的临时结果，后面可以像表一样按名字使用，简称 CTE | WITH order_amount AS (SELECT …) SELECT … FROM order_amount |

## 第 6 章 数据库设计：从需求到 E-R 图

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
| <span id="g-数据库设计"></span>数据库设计 | Database Design | 根据业务需求，确定数据库中有哪些表、每张表有哪些列和约束、表之间怎样关联的过程 | 为网上订货新增地址、网上订单、明细、积分流水 4 张表 |
| <span id="g-需求分析"></span>需求分析 | Requirements Analysis | 数据库设计的第一步：通过访谈、观察业务流程，弄清楚要存哪些数据、要做哪些查询、有哪些规则 | 访谈老板、收银员和配送员，整理出 6 条需求 |
| <span id="g-数据字典"></span>数据字典 | Data Dictionary | 对数据库中每个数据项（名称、含义、类型、长度、取值范围、是否可空等）的详细说明，是设计和开发人员共同的参照 | 送货时段：文字，上午/下午/晚上三选一，不可空 |
| <span id="g-概念设计"></span>概念设计 | Conceptual Design | 把需求整理成与具体数据库软件无关的模型，通常用 E-R 图表示有哪些实体、属性和联系 | 画出网上订货的 E-R 图 |
| <span id="g-实体"></span>实体 | Entity | 现实中可以区分开、需要记录信息的“东西”，如顾客、商品、订单；同一类实体的集合叫实体集 | 顾客、商品、网上订单、收货地址 |
| <span id="g-联系"></span>联系 | Relationship | 实体之间的关系，如顾客“下”订单、订单“包含”商品；联系也可以有自己的属性 | 顾客“下”网上订单 |
| <span id="g-多对多联系"></span>多对多联系 | Many-to-Many Relationship | 两个实体中，每一方的一个都可以对应另一方的多个，如订单和商品；转成表时要建中间表 | 订单 M : N 商品 |
| <span id="g-E-R-图"></span>E-R 图 | Entity-Relationship Diagram | 用图形表示实体、属性和联系的设计图，常见陈氏表示法和乌鸦脚表示法两种画法 | 陈氏表示法：矩形、椭圆、菱形 |
| <span id="g-逻辑设计"></span>逻辑设计 | Logical Design | 把 E-R 图按规则转换成关系模式，确定每张表的列、主键和外键 | 顾客 1 : N 地址 → address 表加 customer_id |
| <span id="g-中间表"></span>中间表 | Junction Table | 为了表示多对多联系而单独建立的表，包含两边实体的主键（作为外键）和联系自身的属性，也叫关联表 | order_item、owner_house |
| <span id="g-物理设计"></span>物理设计 | Physical Design | 为关系模式选定具体数据库软件中的数据类型、约束、索引和存储方式，得到可以运行的建表脚本 | 送货时段用 ENUM，使用积分加 CHECK (points_used >= 0) |

## 第 7 章 规范化与范式

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
| <span id="g-数据冗余"></span>数据冗余 | Data Redundancy | 同一条信息在数据库中被重复存储多次，会浪费空间并引起插入、删除、更新异常 | 杨萱子的电话在大表里存了 38 遍 |
| <span id="g-异常"></span>异常 | Anomaly | 设计不好的表在插入、删除、修改数据时出现的问题，分为插入异常、删除异常和更新异常 | 插入异常、删除异常、更新异常 |
| <span id="g-函数依赖"></span>函数依赖 | Functional Dependency | 如果属性 A 的值确定了，属性 B 的值就唯一确定，称 B 函数依赖于 A，记作 A → B | customer_id → customer_name |
| <span id="g-部分依赖"></span>部分依赖 | Partial Dependency | 非主属性只依赖于复合码中的一部分属性，而不需要整个码就能确定，是不满足第二范式的原因 | (order_id, product_id) 为码时，product_id → product_name |
| <span id="g-传递依赖"></span>传递依赖 | Transitive Dependency | A → B、B → C，且 B 不能决定 A，则 C 通过 B 间接依赖于 A，是不满足第三范式的原因 | order_id → customer_id → customer_phone |
| <span id="g-范式"></span>范式 | Normal Form | 关系模式满足的规范化程度的级别，常用的有第一、第二、第三范式和 BC 范式，级别越高冗余越少 | 1NF、2NF、3NF、BCNF |
| <span id="g-规范化"></span>规范化 | Normalization | 通过拆分关系模式消除不合适的函数依赖、减少冗余、使其达到更高范式的过程 | 把订单大表拆成顾客、订单、明细、商品 4 张表 |
| <span id="g-BC-范式"></span>BC 范式 | Boyce-Codd Normal Form (BCNF) | 每一个函数依赖的决定因素都包含候选码的关系模式，是比第三范式更严格的范式，简称 BCNF | sct(学生, 课程, 教师) 中 教师 → 课程 违反 BCNF |
| <span id="g-反规范化"></span>反规范化 | Denormalization | 为了提高查询速度或简化查询，有意保留冗余数据、降低范式级别的设计做法，需要额外措施保证数据一致 | 订单表存订单总金额 |

## 第 8 章 视图、索引与查询优化

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
| <span id="g-视图"></span>视图 | View | 保存在数据库中的一条 SELECT 查询，使用时像一张表，但本身不存数据，数据来自它所查询的基本表 | CREATE VIEW v_cashier_product AS SELECT product_id, name, price, stock FROM product; |
| <span id="g-全表扫描"></span>全表扫描 | Full Table Scan | 不借助索引，把表中的每一行都读一遍来找满足条件的行；EXPLAIN 中 type 显示为 ALL | EXPLAIN 中 type = ALL，rows ≈ 100 万 |
| <span id="g-索引"></span>索引 | Index | 按某一列或几列的值排好序、带有指向数据行位置的辅助结构，像书的目录，能让查询不用逐行查找 | CREATE INDEX idx_customer ON orders_big (customer_id); |
| <span id="g-B+-树"></span>B+ 树 | B+ Tree | 数据库索引最常用的数据结构，像一棵倒过来的多层目录树，所有数据都在最底层的叶子上且按顺序串起来，只要几层就能从上百万行中找到目标 | 三四层就能管住上千万行 |
| <span id="g-聚簇索引"></span>聚簇索引 | Clustered Index | 叶子节点存放整行数据的索引，InnoDB 中一般就是主键索引，表的数据本身就按主键顺序存放在这棵 B+ 树上 | InnoDB 表的主键索引 |
| <span id="g-二级索引"></span>二级索引 | Secondary Index | 除聚簇索引以外的索引，叶子上存索引列的值和对应行的主键，找到主键后还要回到聚簇索引取整行 | idx_customer 的叶子存 (customer_id, order_id) |
| <span id="g-组合索引"></span>组合索引 | Composite Index | 在多列上共同建立的一个索引，先按第一列排序，第一列相同时再按第二列排序，依此类推 | CREATE INDEX idx_cust_time ON orders_big (customer_id, order_time); |
| <span id="g-最左前缀"></span>最左前缀 | Leftmost Prefix | 组合索引只有在查询条件包含它最左边的一列（或从左起连续的几列）时才能被有效使用的规则 | (customer_id, order_time) 上只查 order_time 用不上索引 |
| <span id="g-执行计划"></span>执行计划 | Execution Plan | 数据库决定如何执行一条查询的方案，包括访问哪张表、用不用索引、预计检查多少行，可用 EXPLAIN 查看 | EXPLAIN SELECT * FROM orders_big WHERE customer_id = 12345; |
| <span id="g-慢查询日志"></span>慢查询日志 | Slow Query Log | MySQL 把执行时间超过设定值的 SQL 自动记录下来的日志文件，用来找出需要优化的查询 | SET GLOBAL slow_query_log = ON; |

## 第 9 章 事务、存储过程与触发器

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
| <span id="g-事务"></span>事务 | Transaction | 由一组 SQL 操作组成的不可分割的工作单位，其中的操作要么全部成功并保存，要么全部撤销 | 下单时“插订单 + 插明细 + 扣库存”放在 START TRANSACTION … COMMIT 之间 |
| <span id="g-提交"></span>提交 | Commit | 结束事务并把事务中的全部修改永久保存到数据库，用 COMMIT 语句 | COMMIT; 之后其他会话才能看到修改 |
| <span id="g-回滚"></span>回滚 | Rollback | 撤销事务中尚未提交的全部修改，使数据回到事务开始前的状态，用 ROLLBACK 语句 | 插入明细报错 1452 后执行 ROLLBACK，薯片库存回到 8 |
| <span id="g-ACID"></span>ACID | ACID | 事务的四个特性：原子性 Atomicity、一致性 Consistency、隔离性 Isolation、持久性 Durability | 转账要么两边都改、要么都不改（原子性） |
| <span id="g-并发"></span>并发 | Concurrency | 多个用户或程序在同一时间访问、修改同一个数据库 | 两个收银台同时修改同一件商品的价格 |
| <span id="g-脏读"></span>脏读 | Dirty Read | 一个事务读到了另一个事务修改了但还没有提交的数据，而那个修改后来可能被撤销 | 会话 B 读到会话 A 未提交的价格 9.90，A 回滚后价格又是 8.90 |
| <span id="g-不可重复读"></span>不可重复读 | Non-repeatable Read | 在同一个事务中两次读取同一行数据，因为中间有其他事务修改并提交，结果不一样 | 同一事务内两次读价格，先 8.90 后 9.90 |
| <span id="g-幻读"></span>幻读 | Phantom Read | 在同一个事务中两次按相同条件查询，因为中间有其他事务插入或删除了行，返回的行数不一样 | 同一事务内两次统计订单数，第二次多出别人新插入的一行 |
| <span id="g-隔离级别"></span>隔离级别 | Isolation Level | 规定一个事务能看到其他并发事务修改的程度，从低到高为读未提交、读已提交、可重复读、可串行化 | SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; |
| <span id="g-锁"></span>锁 | Lock | 数据库为了防止多个事务同时修改同一数据而施加的控制，一个事务持有某行的锁时，其他事务要修改这行必须等待 | 会话 A 改着一行没提交，会话 B 改同一行要等，超时报 1205 |
| <span id="g-存储过程"></span>存储过程 | Stored Procedure | 保存在数据库中、有名字的一组 SQL 语句，可以带参数，用 CALL 调用 | CALL sp_month_summary('2026-05'); 返回 141 单、9936.40 元 |
| <span id="g-存储函数"></span>存储函数 | Stored Function | 保存在数据库中、用 RETURN 返回一个值的程序，可以像 ROUND、CONCAT 等内置函数一样写在 SQL 表达式里 | SELECT fn_order_amount(2499); 返回 152.60 |
| <span id="g-触发器"></span>触发器 | Trigger | 绑定在某张表上、在插入、修改或删除行时由数据库自动执行的一段程序 | trg_item_stock：插入订单明细后自动扣库存 |
| <span id="g-事件"></span>事件 | Event | MySQL 中按设定的时间或周期自动执行的任务，由事件调度器负责运行 | ev_month_summary：每月 1 日凌晨自动生成上月汇总 |

## 第 10 章 数据库管理：安装配置、权限、备份与安全

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|

## 第 11 章 用 Python 开发数据库应用

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|

## 第 12 章 向量数据库原理

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
