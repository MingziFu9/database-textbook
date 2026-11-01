---
title: 常见问题
description: 按类别整理的 30 个常见问题，每个答案都链接回教材正文
---

# 常见问题

这里按类别整理了学习本课程时最常遇到的问题。点开问题查看简短的回答，想深入了解，就顺着链接回到正文对应的小节。各章实验后的“常见问题排查”表和[附录 B.6](../appendix/b-environment.md#b6) 的报错速查，列出了做实验时常见的现象和处理办法。

| 类别 | 问题数 |
|---|---|
| [课程与学习方法](#faq-1) | 6 |
| [安装与实验环境](#faq-2) | 6 |
| [SQL 写法](#faq-3) | 7 |
| [数据库设计](#faq-4) | 4 |
| [索引、事务与管理](#faq-5) | 4 |
| [Python 与向量数据库](#faq-6) | 3 |

## 课程与学习方法 { #faq-1 }

??? question "我没学过数据库，数学和英语也一般，能学会这门课吗？"

    能。本书按零基础编写，从“Excel 表格有什么不够用”讲起，每个概念先用小店的例子讲直观，再讲术语。全书几乎不用数学，只有第 12 章算一下向量的相似度，也有“算一算”例题。SQL 关键字是英文，但常用的只有几十个，书里都配了中文解释，[附录 A](../appendix/a-sql.md) 可以随时查。

??? question "这门课和《Python 编程》是什么关系？要先会 Python 吗？"

    第 1～10 章只用 SQL，不需要 Python。第 11 章用 Python 连接数据库，第 12 章用 Python 做向量搜索，这两章的代码都完整给出，你的任务是运行、改参数、看懂结果；遇到不熟的 Python 语法，回到《Python 编程》复习。本书的小店案例也接着《Python 编程》的小店往下讲。

??? question "★ 和 ☆ 实验有什么区别？都要做吗？"

    ★ 是基础实验，每章两个，建议都做，期末考试的 SQL 题和设计题都来自这些内容；☆ 是拓展实验，可以按时间选做。每个实验都给了完整的 SQL 或代码、编者的运行结果和记录表。见[1.6 节](../chapters/01-overview/index.md#16)。

??? question "书上的“运行结果”和我运行的不一样，是我做错了吗？"

    先看是不是“本来就会不一样”：版本号的最后一位、运行时间（秒数）、自动生成的编号会不同，这些不算错。行数和数值不一样，一般是数据被前面的实验改过了，重新执行 `labs/data/shop_mysql.sql` 还原示例库再试。见[附录 C.4](../appendix/c-shop-db.md#c4)。

??? question "标着“待实测”的是什么意思？"

    全书只有实验 12-2 的第二部分标了“待实测”：它要从网上下载 bge-small-zh-v1.5 嵌入模型，编者的编写环境下载不到，所以没有给出运行结果，而是附了记录表，请你在学校机房（能访问 Hugging Face 或魔搭）运行后自己填写。其余所有结果都是编者实际运行得到的。见[实验 12-2](../chapters/12-vector-db/index.md#12-2-chroma)。

??? question "期末闭卷考试怎么准备？"

    先把每章“本章小结”过一遍，再做[附录 F](../appendix/f-mock-exam.md) 的两套模拟卷，限时 100 分钟、不看书。SQL 题要能**手写**，平时做实验时不要只靠复制粘贴，至少自己敲一遍。[学习图谱](../learning-graph/index.md)可以帮你把概念串起来。

## 安装与实验环境 { #faq-2 }

??? question "我的电脑装不了 MySQL 怎么办？"

    三条路：一是用书中网页上的“试一试”框，不用装任何软件，第 1～5 章的大部分 SQL 都能在浏览器里运行；二是用 Docker 一键启动（[10.3 节](../chapters/10-administration/index.md#103-docker)）；三是在学校机房做。见[附录 B](../appendix/b-environment.md)。

??? question "为什么用 MySQL 8.4，不用最新版或者 5.7？"

    8.4 是 MySQL 官方的长期支持版（LTS），会维护很多年，企业新项目常用；5.7 已经停止维护。最新的创新版（9.x）功能变化快，不适合教学。见[1.6.1 节](../chapters/01-overview/index.md#161)。

??? question "网页“试一试”里的结果和 MySQL 里有一点不同？"

    “试一试”用的是浏览器里的 SQLite 数据库，数据和 shop 一样，但有少数差异：金额显示为 3.5 而不是 3.50；有些 MySQL 专有函数用的是编者补上的简化版。以 MySQL 的结果为准。

??? question "忘了 root 口令怎么办？"

    按官方手册的办法用 `--init-file` 重设，步骤见[附录 B.5](../appendix/b-environment.md#b5-root)。以后把口令记在实验报告第一页。

??? question "DBeaver 连不上 MySQL，提示 Public Key Retrieval is not allowed？"

    在连接设置的“驱动属性”里把 `allowPublicKeyRetrieval` 改成 `true`。其他连接报错见[附录 B.6](../appendix/b-environment.md#b6)。

??? question "国产数据库要不要学？"

    本书第 1 章和第 9 章“前沿视窗”介绍了达梦、人大金仓、OceanBase、TiDB 等国产数据库。它们大多兼容 MySQL 或 PostgreSQL 的语法，学好本书的 SQL，换到国产数据库上很快就能上手。见[1.4 节](../chapters/01-overview/index.md#14)。

## SQL 写法 { #faq-3 }

??? question "SQL 关键字要大写吗？表名区分大小写吗？"

    关键字大小写都可以，本书习惯大写，便于和表名、列名区分。表名在 Windows 上不区分大小写，在 Linux 上默认区分，所以统一用小写最省事。语句末尾的分号、逗号、引号必须是英文的。见[3.1.3 节](../chapters/03-sql-ddl-dml/index.md#313)。

??? question "WHERE 和 HAVING 有什么区别？"

    WHERE 在分组**之前**筛选行，不能用聚合函数；HAVING 在分组**之后**筛选组，可以用聚合函数。能放在 WHERE 里的条件尽量放在 WHERE 里，参与分组的行少，速度快。见[4.5.3 节](../chapters/04-single-table-query/index.md#453-having)和[4.6 节](../chapters/04-single-table-query/index.md#46-sql)。

??? question "为什么 WHERE 里不能用 SELECT 里起的别名？"

    因为执行顺序是 FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY，执行 WHERE 时 SELECT 还没执行，别名还不存在；ORDER BY 在 SELECT 之后，所以可以用别名。见[4.6 节](../chapters/04-single-table-query/index.md#46-sql)。

??? question "`= NULL` 为什么查不出东西？"

    NULL 表示“未知”，任何值和 NULL 比较的结果都是“未知”，既不是真也不是假，所以要用 `IS NULL`、`IS NOT NULL`。NULL 还会让 `NOT IN` 一行也查不出、让 `AVG` 的分母变小。见[4.7 节](../chapters/04-single-table-query/index.md#47-null)。

??? question "连接和子查询都能做的题，用哪个？"

    能用连接写清楚的优先用连接，结果里要显示两张表的列时只能用连接；“找出满足某个条件的行”这类问题，子查询读起来更直观。MySQL 8 对两种写法的优化都不错，性能差别通常不大。见[5.5.5 节](../chapters/05-multi-table-query/index.md#555)。

??? question "左连接查出来的行比预想的多或少？"

    多了：右表一行对应多行时，左表那一行会重复出现（比如一个顾客有 10 笔订单）。少了：把右表的条件写在了 WHERE 里，把 NULL 行过滤掉了，左连接变成了内连接，应该把条件写在 ON 里。见[5.3.4 节](../chapters/05-multi-table-query/index.md#534-on-where)。

??? question "UPDATE 忘了写 WHERE，把整张表改了，怎么办？"

    如果还在没提交的事务里，执行 `ROLLBACK`；如果已经提交了，只能用备份加二进制日志恢复（[10.5 节](../chapters/10-administration/index.md#105)）。预防：先用 SELECT 看看会影响哪些行，确认后再改成 UPDATE。见[3.6.4 节](../chapters/03-sql-ddl-dml/index.md#364-where)。

## 数据库设计 { #faq-4 }

??? question "一对多、多对多怎么判断？"

    两个方向各问一次：“一个 A 能对应几个 B？”“一个 B 能对应几个 A？”两个答案都是“一个”就是一对一，一个“一个”一个“多个”就是一对多，两个都是“多个”就是多对多。判断不了时去问业务人员，不要猜。见[6.3.2 节](../chapters/06-er-design/index.md#632)。

??? question "外键加在哪一边？"

    一对多：加在“多”的一方（订单表里放顾客编号）；多对多：另建一张中间表，放两边的主键；一对一：加在任意一方，通常加在“可有可无”的那一方，并加唯一约束。见[6.4.1 节](../chapters/06-er-design/index.md#641)和[E-R 图转换成表](../sims/er-to-table/index.md)动画。

??? question "范式越高越好吗？"

    一般设计到第三范式就够了。范式越高，表拆得越细，冗余越少，但查询时要连接的表越多。像订单明细里保存“成交单价”这样有意保留的冗余，叫反规范化，只要写清楚理由就可以。见[7.6 节](../chapters/07-normalization/index.md#76)。

??? question "怎么判断一张表满足第几范式？"

    按固定步骤：先找码，再看有没有部分依赖（有就不满足 2NF），再看有没有传递依赖（有就不满足 3NF）。见[7.5 节](../chapters/07-normalization/index.md#75)，[从大表到第三范式](../sims/normal-forms/index.md)动画可以一步步演示。

## 索引、事务与管理 { #faq-5 }

??? question "既然索引能加快查询，为什么不给每一列都建索引？"

    索引要占空间，而且每次插入、修改、删除数据都要同步更新索引，索引越多写入越慢。只给经常出现在 WHERE、JOIN、ORDER BY 里、而且值比较分散的列建索引。见[8.3.3 节](../chapters/08-view-index/index.md#833)和[8.3.4 节](../chapters/08-view-index/index.md#834)。

??? question "建了索引，EXPLAIN 显示却没用上？"

    最常见的原因：在列上用了函数或计算（如 `YEAR(order_time) = 2026`）、`LIKE` 以 `%` 开头、组合索引没从最左边的列开始用、类型不一致发生了隐式转换。见[8.5 节](../chapters/08-view-index/index.md#85)。

??? question "MySQL 默认的隔离级别能防止哪些问题？"

    默认是可重复读（REPEATABLE READ），能防止脏读和不可重复读；按 SQL 标准还可能幻读，但 InnoDB 做了加强，普通查询读快照，大多数情况下也不会幻读。见[9.2.2 节](../chapters/09-transaction/index.md#922)，[隔离级别](../sims/isolation-levels/index.md)动画可以逐步演示。

??? question "备份做了，怎么知道能不能恢复？"

    定期在另一台机器或另一个库里真的恢复一次，并核对行数和金额合计，像[实验 10-2](../chapters/10-administration/index.md#10-2) 那样。没恢复过的备份不能算可靠的备份。见[10.5.5 节](../chapters/10-administration/index.md#1055)。

## Python 与向量数据库 { #faq-6 }

??? question "程序里的数据库口令写在哪里？"

    不要写进代码，放在单独的配置文件（如 `db_config.ini`）或环境变量里，配置文件不要上传到网上的代码仓库；程序使用的账号只给它需要的权限。见[11.3.1 节](../chapters/11-python-app/index.md#1131)。

??? question "向量数据库会取代 MySQL 吗？"

    不会，两者解决的问题不同。MySQL 擅长精确的增删改查、事务和统计，订单、库存这类数据离不开它；向量数据库擅长“按意思找相似的内容”，结果是近似的。实际系统常常两者一起用，或者直接在 PostgreSQL 里用 pgvector 扩展。见[12.5.1 节](../chapters/12-vector-db/index.md#1251)和[12.6 节](../chapters/12-vector-db/index.md#126)。

??? question "RAG 里哪些步骤是数据库的工作？"

    切块后的资料和向量的存储、建索引、按问题向量检索最相似的几段、按元数据和权限过滤，都是数据库的工作；把资料拼成提示词、让大模型生成回答属于大模型应用开发。见[12.7.2 节](../chapters/12-vector-db/index.md#1272-rag)和[RAG 检索流程](../sims/rag-flow/index.md)动画。
