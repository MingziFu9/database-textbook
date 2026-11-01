---
title: SELECT 的执行顺序
description: 一步步播放一条带 WHERE、GROUP BY、HAVING、ORDER BY、LIMIT 的查询，看每一步之后中间表的样子，理解为什么 WHERE 里不能用聚合函数和别名（第 4 章）
---

# SELECT 的执行顺序

<iframe class="sim-frame" src="main.html" height="620" loading="lazy" title="SELECT 的执行顺序"></iframe>

[全屏打开](main.html){ target=_blank } · 对应教材：[4.6 SQL 的书写顺序和执行顺序](../../chapters/04-single-table-query/index.md#46-sql)

## 教学说明

**学习目标**

1. 能说出 SELECT 各子句的执行顺序（记忆）；
2. 能用执行顺序解释“WHERE 里不能写聚合函数和 SELECT 中的别名，ORDER BY 里却可以用别名”（理解）。

**画面与操作**

- 左边是查询语句，每个子句前的编号是执行顺序；点“下一步”，当前子句高亮；
- 右边显示这一步之后的中间结果：48 行 → 46 行 → 8 组 → 6 组 → 6 行 → 排序 → 3 行。

**数据来源**：示例库 shop 的 product 表；最终结果与 MySQL 执行结果一致（类别 1、3、2，平均价 44.08、30.52、24.75）。

**课堂用法建议**

1. 播放前先问：“这条语句最先执行的是哪一句？”；
2. 停在第 ② 步，问“如果把 WHERE 改成 WHERE 平均价 > 30 会怎样？”，再看第 ⑤ 步别名才产生。
