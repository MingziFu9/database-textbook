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

## 第 6 章 数据库设计：从需求到 E-R 图

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|

## 第 7 章 规范化与范式

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|

## 第 8 章 视图、索引与查询优化

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|

## 第 9 章 事务、存储过程与触发器

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|

## 第 10 章 数据库管理：安装配置、权限、备份与安全

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|

## 第 11 章 用 Python 开发数据库应用

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|

## 第 12 章 向量数据库原理

| 术语 | 英文 | 定义 | 例子 |
|---|---|---|---|
