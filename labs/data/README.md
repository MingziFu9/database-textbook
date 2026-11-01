# 实验数据说明

全书贯穿使用“社区小店”示例库 shop（接《Python 编程》的小店案例）。数据由 `make_shop_db.py` 用固定随机种子生成，内容为虚构，人名、电话不对应真实的人。时间范围 2025-01-01 到 2026-06-30，书中把 2026-06-30 当作“今天”。

| 文件 | 内容 | 规模 | 使用章节 |
|---|---|---|---|
| `shop_mysql.sql` | MySQL 版建库脚本：建 shop 库、8 张表、主键外键和全部数据 | 约 290 KB | 第 1 章起全书 |
| `shop_postgres.sql` | PostgreSQL 版建库脚本，内容相同 | 约 290 KB | 第 10、12 章 |
| `shop.sqlite` | SQLite 版，网页“试一试”框使用的就是它 | 约 440 KB | 网页 |
| `csv/` | 8 张表的 CSV 文件（UTF-8，带表头） | 8 个文件 | 第 3 章导入练习、第 1 章 pandas 对比 |
| `make_shop_db.py` | 生成以上全部文件的程序 | — | 教师修改数据时用 |

8 张表的行数：category 8、supplier 8、product 48、employee 8、customer 200、member 123、orders 2501、order_item 5811。表结构和各列含义见教材附录 C。

**规模说明**：全部数据都能在普通笔记本电脑上秒级导入。第 8 章的 100 万行订单表由 `ch08/lab8_2_make_big.sql` 在本机生成，不放在仓库里。
