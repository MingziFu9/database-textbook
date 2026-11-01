---
title: 证书考点对照
description: 全国计算机等级考试二级 MySQL 数据库程序设计（2025 年版大纲）的考核内容与本书章节、实验的对照表
---

# 证书考点对照

人才培养方案没有为本课程指定必考证书。和本课程内容最接近的社会证书是**全国计算机等级考试（NCRE）二级 MySQL 数据库程序设计**，想考证的同学可以用本页查漏补缺：学完本书，二级 MySQL 的数据库部分基本都能覆盖；没覆盖的主要是 PHP 编程和公共基础知识两块，需要另外准备。

## 对应证书

| 证书 | 级别 | 发证机构 | 考核依据 | 考核形式 |
|---|---|---|---|---|
| 全国计算机等级考试 MySQL 数据库程序设计（科目代码 63） | 二级 | 教育部教育考试院 | 《全国计算机等级考试二级 MySQL 数据库程序设计考试大纲（2025 年版）》<sup class="cite">[[1]](#refcert-1)</sup> | 上机考试 120 分钟，满分 100 分：单项选择题 40 分（含公共基础知识 10 分），操作题 60 分（基本操作、简单应用、综合应用）；考试环境 MySQL 5.5、PHP |

!!! warning "版本差异"
    考试环境是 MySQL 5.5，本书用 MySQL 8.4。两者的 SQL 写法绝大部分相同，考前要注意几处差别：5.5 不支持 CHECK 约束（能写但不起作用）、窗口函数和 WITH 子句，没有角色（ROLE）；`GRANT` 在 5.5 中可以顺带建用户（`GRANT ... IDENTIFIED BY ...`），8.4 中必须先 `CREATE USER`；8.4 默认开启 `ONLY_FULL_GROUP_BY`，5.5 没有。考前用真题在考试环境里练习几套。

## 考点对照

| 大纲考核内容 | 知识与技能要求（大纲原文要点） | 本书章节 | 实验 | 覆盖程度 |
|---|---|---|---|---|
| 一、基本概念与方法 | 数据库基本概念、数据库系统的特点与结构、数据模型 | [1.1](chapters/01-overview/index.md#11)、[1.2](chapters/01-overview/index.md#12)、[2.1](chapters/02-relational-model/index.md#21) | 实验 1-1 | 本书完整覆盖 |
| | 关系数据库与关系模型 | [2.2～2.5](chapters/02-relational-model/index.md#22) | 实验 2-1、2-2 | 本书完整覆盖 |
| | 数据库设计步骤、关系数据库设计方法 | [第 6 章](chapters/06-er-design/index.md#61)、[第 7 章](chapters/07-normalization/index.md#73) | 实验 6-1～7-2 | 本书完整覆盖 |
| | MySQL 系统特性与工作方式、SQL 与 MySQL 语言结构 | [1.6.1](chapters/01-overview/index.md#161)、[3.1](chapters/03-sql-ddl-dml/index.md#31-sql)、[9.3](chapters/09-transaction/index.md#93) | 实验 1-2 | 本书完整覆盖 |
| 二、SQL 交互操作：数据库 | 创建、选择、修改、删除、查看数据库 | [3.2](chapters/03-sql-ddl-dml/index.md#32) | 实验 3-1 | 本书完整覆盖 |
| 二、SQL 交互操作：数据表 | 创建、更新、重命名、复制、删除、查看表；插入、删除、更新数据 | [3.4～3.7](chapters/03-sql-ddl-dml/index.md#34) | 实验 3-1、3-2 | 本书完整覆盖 |
| | 简单查询、聚合查询、条件查询 | [第 4 章](chapters/04-single-table-query/index.md#41-select) | 实验 4-1、4-2 | 本书完整覆盖 |
| | 连接查询、嵌套查询、联合查询 | [第 5 章](chapters/05-multi-table-query/index.md#52) | 实验 5-1、5-2 | 本书完整覆盖 |
| | 完整性约束的概念、分类、作用；定义、命名、更新约束 | [2.4](chapters/02-relational-model/index.md#24)、[3.4.2～3.4.4](chapters/03-sql-ddl-dml/index.md#342) | 实验 2-2 | 本书完整覆盖 |
| 二、SQL 交互操作：索引 | 索引的概念、作用、存储与分类；创建、查看、删除索引及原则 | [8.2～8.5](chapters/08-view-index/index.md#82) | 实验 8-2、8-3 | 本书完整覆盖 |
| 二、SQL 交互操作：视图 | 视图的概念、特点、与表的区别；创建、修改、删除、查看；通过视图更新和查询数据 | [8.1](chapters/08-view-index/index.md#81) | 实验 8-1 | 本书完整覆盖 |
| 三、数据库编程：触发器 | 概念与作用，创建、删除，种类及区别，使用原则 | [9.5](chapters/09-transaction/index.md#95) | 实验 9-3 | 本书完整覆盖 |
| 三、数据库编程：事件 | 事件与事件调度器，创建、修改、删除事件 | [9.6](chapters/09-transaction/index.md#96) | — | 本书部分覆盖（讲了创建、查看和删除；修改用 ALTER EVENT，考证需补充） |
| 三、数据库编程：存储过程与存储函数 | 概念与区别，过程体的构造，创建、修改、删除和调用 | [9.3](chapters/09-transaction/index.md#93)、[9.4](chapters/09-transaction/index.md#94) | 实验 9-3 | 本书完整覆盖 |
| 四、管理与维护：服务器 | 安装、配置、启动、关闭服务器，客户端管理工具 | [10.1](chapters/10-administration/index.md#101-mysql)、[附录 B](appendix/b-environment.md) | 实验 1-2 | 本书完整覆盖 |
| 四、管理与维护：用户账号 | 创建、修改、删除用户账号 | [10.4.1](chapters/10-administration/index.md#1041) | 实验 10-1 | 本书完整覆盖 |
| 四、管理与维护：账户权限 | 授予、转移、限制、撤销权限 | [10.4.2～10.4.4](chapters/10-administration/index.md#1042-grant-revoke) | 实验 10-1 | 本书部分覆盖（授予、撤销、角色和账号锁定都讲了；权限转移 `WITH GRANT OPTION` 和资源限制本书未讲，考证需补充） |
| 四、管理与维护：备份与恢复 | 备份与恢复的方法；二进制日志的概念、作用与使用 | [10.5](chapters/10-administration/index.md#105) | 实验 10-2 | 本书完整覆盖 |
| 五、应用编程 | PHP 语言基础，用 PHP 进行 MySQL 应用编程，B/S 结构简单应用 | [第 11 章](chapters/11-python-app/index.md#111)（用 Python 讲同样的步骤：连接、执行、取结果、事务、防注入） | 实验 11-1、11-3 | 本系列不覆盖 PHP（本专业用 Python）；步骤和原理相通，考证需另学 PHP 基础语法 |
| 公共基础知识（选择题 10 分） | 数据结构与算法、程序设计基础、软件工程基础、数据库设计基础 | [第 6、7 章](chapters/06-er-design/index.md#61)（数据库设计部分） | — | 本书部分覆盖；其余由《Python 编程》等课程和考试教材补充 |

本书第 12 章向量数据库、第 11 章窗口函数与数据分析、第 10 章 PostgreSQL 对照是专业方向需要的内容，不在等级考试范围内。

## 参考文献

<div class="refs" markdown>

- <span id="refcert-1"></span>[1] 教育部教育考试院. 全国计算机等级考试二级 MySQL 数据库程序设计考试大纲（2025 年版）[EB/OL]. [2026-11-01]. https://jxjy.yznu.edu.cn/_upload/article/files/ba/d9/7ef53e5f49a6a178b0032e40f6b9/93fbb5d7-5fad-4868-a11d-a0b253751745.pdf.
    <span class="ref-note">大纲原文的转载件（遵义师范学院继续教育学院网站），官方发布渠道为全国计算机等级考试网站 ncre.neea.edu.cn。</span>

</div>
