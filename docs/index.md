# 数据库基础与应用

**面向成人教育人工智能技术应用专业（专科）的《课程名称》教材**

<!-- 书名、课程信息框和“目录与实验”表由 python tools/course.py sync 根据 course.yml 生成；全书概览表由 python tools/book_stats.py 生成 -->

<!-- course:start -->
!!! abstract "课程信息"
    5 学分 · 90 学时（理论 72 学时 + 实验 18 学时） · 第 2 学期 · 12 章 · 36 个实验 · 期末闭卷
<!-- course:end -->

## 这本书讲什么

两三段话：这门课研究什么、学生身边哪里用得到、全书从哪里讲到哪里。

## 本书的特点

- **通俗易懂**：用生活中的例子和“算一算”小计算讲清原理，公式只保留最必要的部分；
- **每章动手实验**：★ 为基础实验，☆ 为拓展实验，教师可按课时选做，其余作为课后练习；
- **结果真实**：书中的运行结果都是编者实际运行得到的；编写环境无法运行的部分标为“待实测”，并提供记录表；
- **在线练习**：每章课后的单选、多选和判断题可以在网页上直接作答，并查看解析；
- **贴近岗位与证书**：（有证书的课程写明对应证书，链接到[证书考点对照](certificate.md)）。

## 全书概览

<!-- stats:start -->

| 章 | 正文字数 | 实验 | 课后练习<br>（可在线作答） | 术语 | 参考文献 | 交互动画 |
|---|---|---|---|---|---|---|
| [第 1 章](chapters/01-sample/index.md) | 0.1 万 | 1 | 5（3） | 2 | 1 | 1 |
| **合计** | **0.1 万** | **1** | **5（3）** | **2** | **1** | **1** |

正文字数只统计汉字，不含代码和课后练习；单选、多选和判断题可以在网页上直接作答。配套学习资源：[交互动画](sims/index.md) 1 个 · [学习图谱](learning-graph/index.md) 2 个概念 · [常见问题](faq/index.md) 2 问 · [术语表](appendix/glossary.md) 2 条。

<!-- stats:end -->

## 目录与实验

<!-- toc:start -->
| 章节 | 实验 |
|---|---|
| [第 1 章 数据库概述](chapters/01-overview/index.md) | 实验 1-1 ★ 在网页“试一试”里跑第一批 SQL<br>实验 1-2 ★ 安装 MySQL 8.4 和 DBeaver，导入小店示例库<br>实验 1-3 ☆ 同一份数据，Excel 和数据库各回答三个问题 |
| [第 2 章 关系模型：用表格描述世界](chapters/02-relational-model/index.md) | 实验 2-1 ★ 浏览小店示例库，找出主键和外键<br>实验 2-2 ★ 故意违反三类完整性<br>实验 2-3 ☆ 把“大杂烩”表拆成关系表 |
| [第 3 章 SQL 入门：建库、建表与增删改](chapters/03-sql-ddl-dml/index.md) | 实验 3-1 ★ 建 myshop 库并从 CSV 导入数据<br>实验 3-2 ★ 修改表结构与增删改数据<br>实验 3-3 ☆ 设计并建一张“会员积分流水”表 |
| [第 4 章 单表查询与分组统计](chapters/04-single-table-query/index.md) | 实验 4-1 ★ 回答老板的十个问题<br>实验 4-2 ★ 按月、按商品、按类别统计<br>实验 4-3 ☆ 找出“三个月没来过的老顾客” |
| [第 5 章 多表查询：连接与子查询](chapters/05-multi-table-query/index.md) | 实验 5-1 ★ 四种连接对比<br>实验 5-2 ★ 用连接和子查询完成小店的八个查询<br>实验 5-3 ☆ 找出“买了 A 也买了 B”的商品组合 |
| [第 6 章 数据库设计：从需求到 E-R 图](chapters/06-er-design/index.md) | 实验 6-1 ★ 读 E-R 图，写关系模式<br>实验 6-2 ★ 补全“网上订货与积分”的建表脚本<br>实验 6-3 ☆ 小组设计：社区图书角 |
| [第 7 章 规范化与范式](chapters/07-normalization/index.md) | 实验 7-1 ★ 判断范式<br>实验 7-2 ★ 把订单大表拆到第三范式<br>实验 7-3 ☆ 讨论：小店哪里适合反规范化 |
| [第 8 章 视图、索引与查询优化](chapters/08-view-index/index.md) | 实验 8-1 ★ 为小店建三个视图<br>实验 8-2 ★ 100 万行订单表上的索引对比<br>实验 8-3 ☆ 找出并改写五条“慢 SQL” |
| [第 9 章 事务、存储过程与触发器](chapters/09-transaction/index.md) | 实验 9-1 ★ 用事务完成下单<br>实验 9-2 ★ 两个会话演示隔离级别<br>实验 9-3 ☆ 月度汇总存储过程和改价日志触发器 |
| [第 10 章 数据库管理：安装配置、权限、备份与安全](chapters/10-administration/index.md) | 实验 10-1 ★ 为三个岗位建账号并授权<br>实验 10-2 ★ 备份小店库，删库后恢复<br>实验 10-3 ☆ 在 PostgreSQL 里建小店库并对照写法 |
| [第 11 章 用 Python 开发数据库应用](chapters/11-python-app/index.md) | 实验 11-1 ★ 用 PyMySQL 查询、插入和事务下单<br>实验 11-2 ★ 用窗口函数和 pandas 做月度销售分析<br>实验 11-3 ☆ Streamlit 版小店管理助手 |
| [第 12 章 向量数据库原理](chapters/12-vector-db/index.md) | 实验 12-1 ★ 手算并验证相似度<br>实验 12-2 ★ 用 Chroma 建向量库做商品语义搜索<br>实验 12-3 ☆ 在 pgvector 里用 SQL 做相似度查询 |

附录：[A MySQL 常用 SQL 速查](appendix/a-sql.md) · [B 实验环境安装与常见报错](appendix/b-environment.md) · [C 小店示例数据库说明](appendix/c-shop-db.md) · [D 术语表](appendix/glossary.md) · [E 设计文档模板](appendix/e-templates.md) · [F 期末闭卷模拟卷](appendix/f-mock-exam.md)
<!-- toc:end -->

## 配套资源

- [交互动画](sims/index.md)、[学习图谱](learning-graph/index.md)、[常见问题](faq/index.md)
- 实验代码与数据：仓库中的 `labs/` 目录
- 课件、教案和 Word/PDF 版教材：见仓库的 Releases 页面
