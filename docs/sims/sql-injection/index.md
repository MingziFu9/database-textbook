---
title: SQL 注入演示
description: 在会员登录框里输入手机号或注入串，对比拼接写法和参数化写法生成的 SQL 与查询结果（第 11 章）
---

# SQL 注入演示

<iframe class="sim-frame" src="main.html" height="600" loading="lazy" title="SQL 注入演示"></iframe>

[全屏打开](main.html){ target=_blank } · 对应教材：[11.2.1 两种写法的对比](../../chapters/11-python-app/index.md#1121)

## 教学说明

**学习目标**

1. 能说明拼接 SQL 字符串为什么会被注入（理解）；
2. 能说明参数化查询为什么能防住注入（理解）。

**画面与操作**

- 上面输入手机号或点例子；左右两栏分别显示两种写法实际执行的 SQL（橙色是输入，红色表示输入里带了单引号）和查询结果；
- 下面的说明解释为什么会这样。

**数据来源**：shop 示例库 customer 表的 200 位顾客。五个例子的结果都是编者用 PyMySQL 1.2.3 连 MySQL 8.4.13 实测的（实验 11-1 的 lab11_1_injection.py 加了几个输入）；右栏的转义规则按 PyMySQL 的 escape_string 实现。

**课堂用法建议**

1. 先输入正常手机号，说明两边一样；
2. 点 `' OR '1'='1`，让学生把左边的 SQL 念一遍，找出 WHERE 为什么永远成立；
3. 强调：防注入靠参数化查询，不是靠“检查输入里有没有单引号”。
