---
title: 分组统计与 HAVING
description: 选分组的列和聚合函数，看 48 种商品怎样落进“篮子”、每个篮子怎样变成一行；打开 HAVING 拖动门槛，看哪些组被拿走（第 4 章）
---

# 分组统计与 HAVING

<iframe class="sim-frame" src="main.html" height="600" loading="lazy" title="分组统计与 HAVING"></iframe>

[全屏打开](main.html){ target=_blank } · 对应教材：[4.5 聚合与分组](../../chapters/04-single-table-query/index.md#45)

## 教学说明

**学习目标**

1. 能解释 GROUP BY 把行分组、每组变成一行的过程（理解）；
2. 能区分 WHERE（筛行）和 HAVING（筛组）（理解、应用）。

**画面与操作**

- 左边每个篮子是一组，里面是落进来的商品；底部是这一组的聚合值；
- 右边是结果表；打开 HAVING 并拖动门槛，不满足条件的篮子变灰，结果表中对应的行被划掉；
- 上方实时显示对应的 SQL。

**数据来源**：示例库 shop 的 product 表全部 48 行；数值与 MySQL 中执行结果一致（如按类别 AVG(price) 第 1 类为 39.00）。

**课堂用法建议**

1. 先只分组，让学生说出结果有几行、为什么不能 SELECT name；
2. 打开 HAVING，问“COUNT(*) > 6 有哪几类”，再改成 AVG(price) > 25，对比 WHERE price > 25 的不同。
