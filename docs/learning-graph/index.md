---
title: 学习图谱
description: 全书核心概念及其先修关系，点一个概念就能看到学习路径
---

# 学习图谱

学习图谱把全书的核心概念和它们之间的“先修关系”画在一张图上：要理解一个概念，得先懂哪些更基础的概念；顺着箭头往回找，就是一条学习路径。

<iframe class="sim-frame" src="main.html" height="900" loading="lazy" title="学习图谱"></iframe>

[全屏打开](main.html){ target=_blank }

## 怎样使用

- **预习**：学新的一章前，点开本章的概念，看看橙色的先修概念自己是否都掌握了，没掌握的先回去复习；
- **复习**：期末复习时，从最后几章的概念出发，顺着学习路径往回梳理，就能把全书串起来；
- **查漏补缺**：做练习时遇到不懂的概念，在搜索框里输入它，看它依赖哪些更基础的概念。

<!-- graph:start -->

图谱共有 **143 个概念、178 条先修关系**，概念按章排列，颜色表示 7 个类别（基本概念、SQL 语言、数据库设计、索引与事务、管理与安全、应用开发、向量数据库）。概念的定义都来自[附录 D 术语表](../appendix/glossary.md)，先修关系由编者根据各章内容整理。

## 文字版

下面按章列出每个概念的直接先修概念，便于打印或用读屏软件阅读。

??? note "第 1 章 概述（15 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [数据库](../appendix/glossary.md#g-数据库) | 基本概念 | — |
    | [数据库管理系统](../appendix/glossary.md#g-数据库管理系统) | 基本概念 | [数据库](../appendix/glossary.md#g-数据库) |
    | [数据库系统](../appendix/glossary.md#g-数据库系统) | 基本概念 | [数据库](../appendix/glossary.md#g-数据库)、[数据库管理系统](../appendix/glossary.md#g-数据库管理系统) |
    | [外模式](../appendix/glossary.md#g-外模式) | 基本概念 | [模式](../appendix/glossary.md#g-模式) |
    | [模式](../appendix/glossary.md#g-模式) | 基本概念 | [数据库](../appendix/glossary.md#g-数据库) |
    | [内模式](../appendix/glossary.md#g-内模式) | 基本概念 | [模式](../appendix/glossary.md#g-模式) |
    | [数据独立性](../appendix/glossary.md#g-数据独立性) | 基本概念 | [外模式](../appendix/glossary.md#g-外模式)、[内模式](../appendix/glossary.md#g-内模式) |
    | [关系型数据库](../appendix/glossary.md#g-关系型数据库) | 基本概念 | [数据库管理系统](../appendix/glossary.md#g-数据库管理系统) |
    | [SQL](../appendix/glossary.md#g-SQL) | 基本概念 | [关系型数据库](../appendix/glossary.md#g-关系型数据库) |
    | [MySQL](../appendix/glossary.md#g-MySQL) | 基本概念 | [关系型数据库](../appendix/glossary.md#g-关系型数据库) |
    | [PostgreSQL](../appendix/glossary.md#g-PostgreSQL) | 基本概念 | [关系型数据库](../appendix/glossary.md#g-关系型数据库) |
    | [SQLite](../appendix/glossary.md#g-SQLite) | 基本概念 | [关系型数据库](../appendix/glossary.md#g-关系型数据库) |
    | [NoSQL](../appendix/glossary.md#g-NoSQL) | 基本概念 | [关系型数据库](../appendix/glossary.md#g-关系型数据库) |
    | [向量数据库](../appendix/glossary.md#g-向量数据库) | 基本概念 | [NoSQL](../appendix/glossary.md#g-NoSQL) |
    | [Text-to-SQL](../appendix/glossary.md#g-Text-to-SQL) | 基本概念 | [SQL](../appendix/glossary.md#g-SQL) |

??? note "第 2 章 关系模型（19 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [数据模型](../appendix/glossary.md#g-数据模型) | 基本概念 | [数据库](../appendix/glossary.md#g-数据库) |
    | [关系模型](../appendix/glossary.md#g-关系模型) | 基本概念 | [数据模型](../appendix/glossary.md#g-数据模型) |
    | [关系](../appendix/glossary.md#g-关系) | 基本概念 | [关系模型](../appendix/glossary.md#g-关系模型) |
    | [元组](../appendix/glossary.md#g-元组) | 基本概念 | [关系](../appendix/glossary.md#g-关系) |
    | [属性](../appendix/glossary.md#g-属性) | 基本概念 | [关系](../appendix/glossary.md#g-关系) |
    | [域](../appendix/glossary.md#g-域) | 基本概念 | [属性](../appendix/glossary.md#g-属性) |
    | [关系模式](../appendix/glossary.md#g-关系模式) | 基本概念 | [关系](../appendix/glossary.md#g-关系)、[属性](../appendix/glossary.md#g-属性) |
    | [超键](../appendix/glossary.md#g-超键) | 基本概念 | [属性](../appendix/glossary.md#g-属性)、[元组](../appendix/glossary.md#g-元组) |
    | [候选键](../appendix/glossary.md#g-候选键) | 基本概念 | [超键](../appendix/glossary.md#g-超键) |
    | [主键](../appendix/glossary.md#g-主键) | 基本概念 | [候选键](../appendix/glossary.md#g-候选键) |
    | [外键](../appendix/glossary.md#g-外键) | 基本概念 | [主键](../appendix/glossary.md#g-主键) |
    | [完整性约束](../appendix/glossary.md#g-完整性约束) | 基本概念 | [关系模型](../appendix/glossary.md#g-关系模型) |
    | [实体完整性](../appendix/glossary.md#g-实体完整性) | 基本概念 | [主键](../appendix/glossary.md#g-主键)、[完整性约束](../appendix/glossary.md#g-完整性约束) |
    | [参照完整性](../appendix/glossary.md#g-参照完整性) | 基本概念 | [外键](../appendix/glossary.md#g-外键)、[完整性约束](../appendix/glossary.md#g-完整性约束) |
    | [用户定义完整性](../appendix/glossary.md#g-用户定义完整性) | 基本概念 | [完整性约束](../appendix/glossary.md#g-完整性约束) |
    | [关系代数](../appendix/glossary.md#g-关系代数) | 基本概念 | [关系](../appendix/glossary.md#g-关系) |
    | [选择](../appendix/glossary.md#g-选择) | 基本概念 | [关系代数](../appendix/glossary.md#g-关系代数) |
    | [投影](../appendix/glossary.md#g-投影) | 基本概念 | [关系代数](../appendix/glossary.md#g-关系代数) |
    | [连接](../appendix/glossary.md#g-连接) | 基本概念 | [关系代数](../appendix/glossary.md#g-关系代数)、[外键](../appendix/glossary.md#g-外键) |

??? note "第 3 章 建表与增删改（11 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [声明式语言](../appendix/glossary.md#g-声明式语言) | SQL 语言 | [SQL](../appendix/glossary.md#g-SQL) |
    | [DDL](../appendix/glossary.md#g-DDL) | SQL 语言 | [SQL](../appendix/glossary.md#g-SQL) |
    | [DML](../appendix/glossary.md#g-DML) | SQL 语言 | [SQL](../appendix/glossary.md#g-SQL) |
    | [DQL](../appendix/glossary.md#g-DQL) | SQL 语言 | [SQL](../appendix/glossary.md#g-SQL) |
    | [DCL](../appendix/glossary.md#g-DCL) | SQL 语言 | [SQL](../appendix/glossary.md#g-SQL) |
    | [字符集](../appendix/glossary.md#g-字符集) | SQL 语言 | [DDL](../appendix/glossary.md#g-DDL) |
    | [数据类型](../appendix/glossary.md#g-数据类型) | SQL 语言 | [DDL](../appendix/glossary.md#g-DDL)、[域](../appendix/glossary.md#g-域) |
    | [非空约束](../appendix/glossary.md#g-非空约束) | SQL 语言 | [完整性约束](../appendix/glossary.md#g-完整性约束)、[DDL](../appendix/glossary.md#g-DDL) |
    | [唯一约束](../appendix/glossary.md#g-唯一约束) | SQL 语言 | [候选键](../appendix/glossary.md#g-候选键)、[DDL](../appendix/glossary.md#g-DDL) |
    | [默认值](../appendix/glossary.md#g-默认值) | SQL 语言 | [DDL](../appendix/glossary.md#g-DDL) |
    | [检查约束](../appendix/glossary.md#g-检查约束) | SQL 语言 | [用户定义完整性](../appendix/glossary.md#g-用户定义完整性)、[DDL](../appendix/glossary.md#g-DDL) |

??? note "第 4 章 单表查询（10 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [查询](../appendix/glossary.md#g-查询) | SQL 语言 | [DQL](../appendix/glossary.md#g-DQL) |
    | [别名](../appendix/glossary.md#g-别名) | SQL 语言 | [查询](../appendix/glossary.md#g-查询) |
    | [DISTINCT](../appendix/glossary.md#g-DISTINCT) | SQL 语言 | [查询](../appendix/glossary.md#g-查询) |
    | [通配符](../appendix/glossary.md#g-通配符) | SQL 语言 | [查询](../appendix/glossary.md#g-查询) |
    | [分页](../appendix/glossary.md#g-分页) | SQL 语言 | [查询](../appendix/glossary.md#g-查询) |
    | [CASE 表达式](../appendix/glossary.md#g-CASE-表达式) | SQL 语言 | [查询](../appendix/glossary.md#g-查询) |
    | [聚合函数](../appendix/glossary.md#g-聚合函数) | SQL 语言 | [查询](../appendix/glossary.md#g-查询) |
    | [分组](../appendix/glossary.md#g-分组) | SQL 语言 | [聚合函数](../appendix/glossary.md#g-聚合函数) |
    | [HAVING](../appendix/glossary.md#g-HAVING) | SQL 语言 | [分组](../appendix/glossary.md#g-分组) |
    | [执行顺序](../appendix/glossary.md#g-执行顺序) | SQL 语言 | [HAVING](../appendix/glossary.md#g-HAVING)、[别名](../appendix/glossary.md#g-别名) |

??? note "第 5 章 多表查询（11 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [笛卡尔积](../appendix/glossary.md#g-笛卡尔积) | SQL 语言 | [连接](../appendix/glossary.md#g-连接) |
    | [表别名](../appendix/glossary.md#g-表别名) | SQL 语言 | [别名](../appendix/glossary.md#g-别名) |
    | [内连接](../appendix/glossary.md#g-内连接) | SQL 语言 | [连接](../appendix/glossary.md#g-连接)、[表别名](../appendix/glossary.md#g-表别名) |
    | [外连接](../appendix/glossary.md#g-外连接) | SQL 语言 | [内连接](../appendix/glossary.md#g-内连接) |
    | [自连接](../appendix/glossary.md#g-自连接) | SQL 语言 | [内连接](../appendix/glossary.md#g-内连接)、[表别名](../appendix/glossary.md#g-表别名) |
    | [子查询](../appendix/glossary.md#g-子查询) | SQL 语言 | [查询](../appendix/glossary.md#g-查询) |
    | [EXISTS](../appendix/glossary.md#g-EXISTS) | SQL 语言 | [子查询](../appendix/glossary.md#g-子查询) |
    | [相关子查询](../appendix/glossary.md#g-相关子查询) | SQL 语言 | [子查询](../appendix/glossary.md#g-子查询) |
    | [派生表](../appendix/glossary.md#g-派生表) | SQL 语言 | [子查询](../appendix/glossary.md#g-子查询)、[表别名](../appendix/glossary.md#g-表别名) |
    | [UNION](../appendix/glossary.md#g-UNION) | SQL 语言 | [查询](../appendix/glossary.md#g-查询) |
    | [公用表表达式](../appendix/glossary.md#g-公用表表达式) | SQL 语言 | [派生表](../appendix/glossary.md#g-派生表) |

??? note "第 6 章 E-R 设计（11 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [数据库设计](../appendix/glossary.md#g-数据库设计) | 数据库设计 | [关系模型](../appendix/glossary.md#g-关系模型) |
    | [需求分析](../appendix/glossary.md#g-需求分析) | 数据库设计 | [数据库设计](../appendix/glossary.md#g-数据库设计) |
    | [数据字典](../appendix/glossary.md#g-数据字典) | 数据库设计 | [需求分析](../appendix/glossary.md#g-需求分析) |
    | [概念设计](../appendix/glossary.md#g-概念设计) | 数据库设计 | [需求分析](../appendix/glossary.md#g-需求分析) |
    | [实体](../appendix/glossary.md#g-实体) | 数据库设计 | [概念设计](../appendix/glossary.md#g-概念设计) |
    | [联系](../appendix/glossary.md#g-联系) | 数据库设计 | [实体](../appendix/glossary.md#g-实体) |
    | [多对多联系](../appendix/glossary.md#g-多对多联系) | 数据库设计 | [联系](../appendix/glossary.md#g-联系) |
    | [E-R 图](../appendix/glossary.md#g-E-R-图) | 数据库设计 | [实体](../appendix/glossary.md#g-实体)、[联系](../appendix/glossary.md#g-联系) |
    | [逻辑设计](../appendix/glossary.md#g-逻辑设计) | 数据库设计 | [E-R 图](../appendix/glossary.md#g-E-R-图)、[关系模式](../appendix/glossary.md#g-关系模式) |
    | [中间表](../appendix/glossary.md#g-中间表) | 数据库设计 | [多对多联系](../appendix/glossary.md#g-多对多联系)、[外键](../appendix/glossary.md#g-外键) |
    | [物理设计](../appendix/glossary.md#g-物理设计) | 数据库设计 | [逻辑设计](../appendix/glossary.md#g-逻辑设计)、[数据类型](../appendix/glossary.md#g-数据类型) |

??? note "第 7 章 范式（9 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [数据冗余](../appendix/glossary.md#g-数据冗余) | 数据库设计 | [关系模式](../appendix/glossary.md#g-关系模式) |
    | [异常](../appendix/glossary.md#g-异常) | 数据库设计 | [数据冗余](../appendix/glossary.md#g-数据冗余) |
    | [函数依赖](../appendix/glossary.md#g-函数依赖) | 数据库设计 | [属性](../appendix/glossary.md#g-属性) |
    | [部分依赖](../appendix/glossary.md#g-部分依赖) | 数据库设计 | [函数依赖](../appendix/glossary.md#g-函数依赖)、[候选键](../appendix/glossary.md#g-候选键) |
    | [传递依赖](../appendix/glossary.md#g-传递依赖) | 数据库设计 | [函数依赖](../appendix/glossary.md#g-函数依赖) |
    | [范式](../appendix/glossary.md#g-范式) | 数据库设计 | [函数依赖](../appendix/glossary.md#g-函数依赖)、[异常](../appendix/glossary.md#g-异常) |
    | [规范化](../appendix/glossary.md#g-规范化) | 数据库设计 | [范式](../appendix/glossary.md#g-范式)、[部分依赖](../appendix/glossary.md#g-部分依赖)、[传递依赖](../appendix/glossary.md#g-传递依赖) |
    | [BC 范式](../appendix/glossary.md#g-BC-范式) | 数据库设计 | [规范化](../appendix/glossary.md#g-规范化) |
    | [反规范化](../appendix/glossary.md#g-反规范化) | 数据库设计 | [规范化](../appendix/glossary.md#g-规范化) |

??? note "第 8 章 视图与索引（10 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [视图](../appendix/glossary.md#g-视图) | 索引与事务 | [查询](../appendix/glossary.md#g-查询) |
    | [全表扫描](../appendix/glossary.md#g-全表扫描) | 索引与事务 | [查询](../appendix/glossary.md#g-查询) |
    | [索引](../appendix/glossary.md#g-索引) | 索引与事务 | [全表扫描](../appendix/glossary.md#g-全表扫描) |
    | [B+ 树](../appendix/glossary.md#g-B+-树) | 索引与事务 | [索引](../appendix/glossary.md#g-索引) |
    | [聚簇索引](../appendix/glossary.md#g-聚簇索引) | 索引与事务 | [B+ 树](../appendix/glossary.md#g-B+-树)、[主键](../appendix/glossary.md#g-主键) |
    | [二级索引](../appendix/glossary.md#g-二级索引) | 索引与事务 | [聚簇索引](../appendix/glossary.md#g-聚簇索引) |
    | [组合索引](../appendix/glossary.md#g-组合索引) | 索引与事务 | [索引](../appendix/glossary.md#g-索引) |
    | [最左前缀](../appendix/glossary.md#g-最左前缀) | 索引与事务 | [组合索引](../appendix/glossary.md#g-组合索引) |
    | [执行计划](../appendix/glossary.md#g-执行计划) | 索引与事务 | [索引](../appendix/glossary.md#g-索引) |
    | [慢查询日志](../appendix/glossary.md#g-慢查询日志) | 索引与事务 | [执行计划](../appendix/glossary.md#g-执行计划) |

??? note "第 9 章 事务与存储过程（14 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [事务](../appendix/glossary.md#g-事务) | 索引与事务 | [DML](../appendix/glossary.md#g-DML) |
    | [提交](../appendix/glossary.md#g-提交) | 索引与事务 | [事务](../appendix/glossary.md#g-事务) |
    | [回滚](../appendix/glossary.md#g-回滚) | 索引与事务 | [事务](../appendix/glossary.md#g-事务) |
    | [ACID](../appendix/glossary.md#g-ACID) | 索引与事务 | [提交](../appendix/glossary.md#g-提交)、[回滚](../appendix/glossary.md#g-回滚) |
    | [并发](../appendix/glossary.md#g-并发) | 索引与事务 | [事务](../appendix/glossary.md#g-事务) |
    | [脏读](../appendix/glossary.md#g-脏读) | 索引与事务 | [并发](../appendix/glossary.md#g-并发)、[提交](../appendix/glossary.md#g-提交) |
    | [不可重复读](../appendix/glossary.md#g-不可重复读) | 索引与事务 | [并发](../appendix/glossary.md#g-并发) |
    | [幻读](../appendix/glossary.md#g-幻读) | 索引与事务 | [并发](../appendix/glossary.md#g-并发) |
    | [隔离级别](../appendix/glossary.md#g-隔离级别) | 索引与事务 | [脏读](../appendix/glossary.md#g-脏读)、[不可重复读](../appendix/glossary.md#g-不可重复读)、[幻读](../appendix/glossary.md#g-幻读) |
    | [锁](../appendix/glossary.md#g-锁) | 索引与事务 | [并发](../appendix/glossary.md#g-并发) |
    | [存储过程](../appendix/glossary.md#g-存储过程) | 索引与事务 | [DML](../appendix/glossary.md#g-DML) |
    | [存储函数](../appendix/glossary.md#g-存储函数) | 索引与事务 | [存储过程](../appendix/glossary.md#g-存储过程) |
    | [触发器](../appendix/glossary.md#g-触发器) | 索引与事务 | [存储过程](../appendix/glossary.md#g-存储过程) |
    | [事件](../appendix/glossary.md#g-事件) | 索引与事务 | [存储过程](../appendix/glossary.md#g-存储过程) |

??? note "第 10 章 数据库管理（13 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [用户账号](../appendix/glossary.md#g-用户账号) | 管理与安全 | [DCL](../appendix/glossary.md#g-DCL) |
    | [权限](../appendix/glossary.md#g-权限) | 管理与安全 | [用户账号](../appendix/glossary.md#g-用户账号) |
    | [角色](../appendix/glossary.md#g-角色) | 管理与安全 | [权限](../appendix/glossary.md#g-权限) |
    | [最小权限原则](../appendix/glossary.md#g-最小权限原则) | 管理与安全 | [权限](../appendix/glossary.md#g-权限) |
    | [备份](../appendix/glossary.md#g-备份) | 管理与安全 | [数据库](../appendix/glossary.md#g-数据库) |
    | [恢复](../appendix/glossary.md#g-恢复) | 管理与安全 | [备份](../appendix/glossary.md#g-备份) |
    | [逻辑备份](../appendix/glossary.md#g-逻辑备份) | 管理与安全 | [备份](../appendix/glossary.md#g-备份) |
    | [增量备份](../appendix/glossary.md#g-增量备份) | 管理与安全 | [备份](../appendix/glossary.md#g-备份) |
    | [二进制日志](../appendix/glossary.md#g-二进制日志) | 管理与安全 | [增量备份](../appendix/glossary.md#g-增量备份) |
    | [时间点恢复](../appendix/glossary.md#g-时间点恢复) | 管理与安全 | [二进制日志](../appendix/glossary.md#g-二进制日志)、[恢复](../appendix/glossary.md#g-恢复) |
    | [SQL 注入](../appendix/glossary.md#g-SQL-注入) | 管理与安全 | [SQL](../appendix/glossary.md#g-SQL) |
    | [数据加密](../appendix/glossary.md#g-数据加密) | 管理与安全 | [用户账号](../appendix/glossary.md#g-用户账号) |
    | [数据脱敏](../appendix/glossary.md#g-数据脱敏) | 管理与安全 | [视图](../appendix/glossary.md#g-视图)、[权限](../appendix/glossary.md#g-权限) |

??? note "第 11 章 Python 应用开发（7 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [数据库驱动](../appendix/glossary.md#g-数据库驱动) | 应用开发 | [MySQL](../appendix/glossary.md#g-MySQL) |
    | [数据库连接](../appendix/glossary.md#g-数据库连接) | 应用开发 | [数据库驱动](../appendix/glossary.md#g-数据库驱动) |
    | [游标](../appendix/glossary.md#g-游标) | 应用开发 | [数据库连接](../appendix/glossary.md#g-数据库连接) |
    | [参数化查询](../appendix/glossary.md#g-参数化查询) | 应用开发 | [游标](../appendix/glossary.md#g-游标)、[SQL 注入](../appendix/glossary.md#g-SQL-注入) |
    | [窗口函数](../appendix/glossary.md#g-窗口函数) | 应用开发 | [分组](../appendix/glossary.md#g-分组) |
    | [数据挖掘](../appendix/glossary.md#g-数据挖掘) | 应用开发 | [窗口函数](../appendix/glossary.md#g-窗口函数) |
    | [ORM](../appendix/glossary.md#g-ORM) | 应用开发 | [数据库连接](../appendix/glossary.md#g-数据库连接) |

??? note "第 12 章 向量数据库（13 个概念）"

    | 概念 | 类别 | 直接先修 |
    |---|---|---|
    | [嵌入](../appendix/glossary.md#g-嵌入) | 向量数据库 | [向量数据库](../appendix/glossary.md#g-向量数据库) |
    | [嵌入模型](../appendix/glossary.md#g-嵌入模型) | 向量数据库 | [嵌入](../appendix/glossary.md#g-嵌入) |
    | [余弦相似度](../appendix/glossary.md#g-余弦相似度) | 向量数据库 | [嵌入](../appendix/glossary.md#g-嵌入) |
    | [欧氏距离](../appendix/glossary.md#g-欧氏距离) | 向量数据库 | [嵌入](../appendix/glossary.md#g-嵌入) |
    | [内积](../appendix/glossary.md#g-内积) | 向量数据库 | [余弦相似度](../appendix/glossary.md#g-余弦相似度) |
    | [最近邻搜索](../appendix/glossary.md#g-最近邻搜索) | 向量数据库 | [余弦相似度](../appendix/glossary.md#g-余弦相似度)、[欧氏距离](../appendix/glossary.md#g-欧氏距离) |
    | [近似最近邻](../appendix/glossary.md#g-近似最近邻) | 向量数据库 | [最近邻搜索](../appendix/glossary.md#g-最近邻搜索)、[索引](../appendix/glossary.md#g-索引) |
    | [召回率](../appendix/glossary.md#g-召回率) | 向量数据库 | [近似最近邻](../appendix/glossary.md#g-近似最近邻) |
    | [HNSW](../appendix/glossary.md#g-HNSW) | 向量数据库 | [近似最近邻](../appendix/glossary.md#g-近似最近邻) |
    | [元数据过滤](../appendix/glossary.md#g-元数据过滤) | 向量数据库 | [最近邻搜索](../appendix/glossary.md#g-最近邻搜索) |
    | [pgvector](../appendix/glossary.md#g-pgvector) | 向量数据库 | [PostgreSQL](../appendix/glossary.md#g-PostgreSQL)、[HNSW](../appendix/glossary.md#g-HNSW) |
    | [检索增强生成](../appendix/glossary.md#g-检索增强生成) | 向量数据库 | [嵌入模型](../appendix/glossary.md#g-嵌入模型)、[最近邻搜索](../appendix/glossary.md#g-最近邻搜索) |
    | [混合检索](../appendix/glossary.md#g-混合检索) | 向量数据库 | [检索增强生成](../appendix/glossary.md#g-检索增强生成)、[通配符](../appendix/glossary.md#g-通配符) |

<!-- graph:end -->
