---
title: 附录 B 实验环境安装与常见报错
description: MySQL 8.4、DBeaver、Docker 和 Python 实验环境的安装步骤，忘记 root 口令的处理办法，以及全书出现过的 MySQL 报错速查
---

# 附录 B 实验环境安装与常见报错

本书的实验环境有三条路线，任选一条即可：

| 路线 | 适合谁 | 得到什么 | 见 |
|---|---|---|---|
| 网页“试一试” | 刚入门、电脑装不了软件时 | 浏览器里的 SQLite 小店库，能跑第 1～5 章大部分 SQL | 各章正文 |
| 直接安装 MySQL + DBeaver | 大多数同学（推荐） | 本机 MySQL 8.4 和图形化客户端 | B.1、B.2 |
| Docker 一键启动 | 已会用 Docker 的同学、机房统一部署 | MySQL 8.4 + 带 pgvector 的 PostgreSQL 17 | B.3 |

第 11、12 章还要用 Python，见 B.4。

## B.1 安装 MySQL 8.4

本书用 MySQL 8.4 LTS（长期支持版），Windows 只有 64 位安装包。步骤（与[实验 1-2](../chapters/01-overview/index.md#1-2-mysql-84-dbeaver) 相同，这里汇总）：

1. 在 `https://dev.mysql.com/downloads/mysql/` 选择版本 **8.4.x LTS**、操作系统 Microsoft Windows，下载 MSI 安装包。提示登录时点“No thanks, just start my download”；
2. 双击安装，类型选 Typical，结束时勾选“Run MySQL Configurator”；
3. 在 MySQL Configurator 中：端口保持 **3306**；设置 root 口令（书中示例用 `shop123`，**一定要记住**）；作为 Windows 服务运行，服务名默认 **MySQL84**，勾选开机自动启动；点 Execute 完成；
4. 开始菜单打开“MySQL 8.4 Command Line Client”，输入口令，看到 `mysql>` 即安装成功。

想在“命令提示符”里直接输入 `mysql`，要把 `C:\Program Files\MySQL\MySQL Server 8.4\bin` 加到系统环境变量 Path 中（“此电脑”右键 → 属性 → 高级系统设置 → 环境变量）。配置文件 `my.ini` 的位置和常改的几项见 [10.1.2 节](../chapters/10-administration/index.md#1012-myini)。

## B.2 安装 DBeaver 并连接

1. 在 `https://dbeaver.io/download/` 下载 Windows 版 **DBeaver Community**（社区版，免费），默认安装；
2. 点左上角插头形状的“新建连接”→ 选 MySQL → 主机 `localhost`、端口 `3306`、用户名 `root`、口令填 B.1 设置的口令；
3. 第一次连接会提示下载 MySQL 驱动，点“下载”；
4. 导入示例库：右键连接 →“SQL 编辑器 → 打开 SQL 脚本”，打开 `labs/data/shop_mysql.sql`，按 Alt+X 执行整个脚本，刷新后出现 shop 库和 8 张表。

DBeaver 常用快捷键：Ctrl+Enter 执行光标所在（或选中）的一条语句；Alt+X 执行整个脚本；Ctrl+/ 注释或取消注释；Ctrl+Shift+F 格式化 SQL。

## B.3 用 Docker 一键启动

已经装好 Docker Desktop 的，在 `labs/docker/` 目录打开终端：

```bash
docker compose up -d                 # 启动 shop-mysql 和 shop-postgres 两个容器
docker exec -i shop-mysql mysql -uroot -pshop123 --default-character-set=utf8mb4 < ../data/shop_mysql.sql
docker exec -i shop-postgres psql -U postgres -c "CREATE DATABASE shop"
docker exec -i shop-postgres psql -U postgres -d shop < ../data/shop_postgres.sql
```

| 容器 | 镜像 | 端口 | 账号 / 口令 |
|---|---|---|---|
| shop-mysql | mysql:8.4 | 3306 | root / shop123 |
| shop-postgres | pgvector/pgvector:pg17 | 5432 | postgres / shop123 |

停止用 `docker compose stop`，再次启动用 `docker compose start`，数据保存在 Docker 卷里不会丢。DBeaver 按 B.2 连接即可。详细说明见 [10.3 节](../chapters/10-administration/index.md#103-docker)。

## B.4 Python 实验环境

第 11、12 章（和第 1 章的拓展实验）要用 Python 3.11 及以上（编者用 3.13）。Python 的安装和 pip 的用法见《Python 编程》。在 `labs/` 目录下执行：

```bash
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

第 12 章实验 12-2 第二部分另需 `pip install sentence-transformers`，并要能下载嵌入模型：在命令提示符里先执行 `set HF_ENDPOINT=https://hf-mirror.com`，或从魔搭社区（modelscope.cn）下载 bge-small-zh-v1.5 模型文件夹，把程序里的 MODEL 改成文件夹路径。

## B.5 忘记 root 口令怎么办 { #b5-root }

按 MySQL 8.4 官方手册的办法（Windows）：<sup class="cite">[[1]](#refB-1)</sup>

1. 以管理员身份登录 Windows，在“服务”里停止 MySQL84 服务；
2. 新建文本文件 `C:\mysql-init.txt`，只写一行（把 `新口令` 换成你要的口令）：

    ```sql
    ALTER USER 'root'@'localhost' IDENTIFIED BY '新口令';
    ```

3. 以管理员身份打开命令提示符，执行（注意路径里的反斜杠要写两个）：

    ```text
    cd "C:\Program Files\MySQL\MySQL Server 8.4\bin"
    mysqld --defaults-file="C:\\ProgramData\\MySQL\\MySQL Server 8.4\\my.ini" --init-file=C:\\mysql-init.txt --console
    ```

    `--defaults-file` 的准确路径可以在“服务”里右键 MySQL84 →“属性”的“可执行文件的路径”中看到；
4. 看到服务器启动完成后，按 Ctrl+C 停止它，**删除** `C:\mysql-init.txt`（里面有明文口令）；
5. 在“服务”里正常启动 MySQL84，用新口令登录。

## B.6 常见报错速查

MySQL 的报错格式是 `ERROR 错误号 (SQLSTATE): 说明`。看错误号就能大致知道是哪一类问题。下表的报错信息都是编者在 MySQL 8.4.13 上实际触发得到的；完整列表见官方的错误参考<sup class="cite">[[2]](#refB-2)</sup>。

**语法和对象名**

| 报错 | 常见原因 | 解决办法 | 见 |
|---|---|---|---|
| `ERROR 1064 (42000): You have an error in your SQL syntax ... near 'SELEC * FROM product'` | 关键字拼错、用了中文标点、少了逗号或引号；`near` 后面就是出错的位置 | 从 near 指出的位置往前找；检查中文逗号、分号、引号 | 3.1.3 |
| `ERROR 1046 (3D000): No database selected` | 没选数据库 | 先 `USE shop;`，或在 DBeaver 顶部选中库 | 4 章实验 |
| `ERROR 1049 (42000): Unknown database 'nosuchdb'` | 库名写错，或库还没建 | `SHOW DATABASES;` 核对 | 3.2 |
| `ERROR 1146 (42S02): Table 'shop.nosuchtable' doesn't exist` | 表名写错，或在错误的库里 | `SHOW TABLES;` 核对 | 3.4 |
| `ERROR 1054 (42S22): Unknown column 'nosuchcol' in 'field list'` | 列名写错；或在 WHERE 里用了 SELECT 中起的别名 | `DESC 表名;` 核对列名；别名条件改用原表达式或放到 HAVING | 4.6 |
| `ERROR 1050 (42S01): Table 'category' already exists` | 重复建表 | 用 `CREATE TABLE IF NOT EXISTS`，或先删除 | 3.4 |
| `ERROR 1055 (42000): Expression #2 of SELECT list is not in GROUP BY clause ...` | 分组查询的 SELECT 里写了既不分组也不聚合的列 | SELECT 里只写分组列和聚合函数 | 4.5.2 |

**数据和约束**

| 报错 | 常见原因 | 解决办法 | 见 |
|---|---|---|---|
| `ERROR 1062 (23000): Duplicate entry '1' for key 'category.PRIMARY'` | 主键或唯一键重复 | 换一个值，或让主键自动增长 | 3.4.2 |
| `ERROR 1048 (23000): Column 'category_id' cannot be null` | 给 NOT NULL 列插入了 NULL | 补上值 | 3.4.2 |
| `ERROR 1136 (21S01): Column count doesn't match value count at row 1` | VALUES 里值的个数和列数不一致 | INSERT 时写明列名 | 3.6.1 |
| `ERROR 1406 (22001): Data too long for column 'name' at row 1` | 字符串超过了 VARCHAR 的长度 | 缩短内容或加大列宽 | 3.3.2 |
| `ERROR 1264 (22003): Out of range value for column 'price' at row 1` | 数值超出类型范围，如 DECIMAL(8,2) 放不下 123456789 | 检查数值或改大类型 | 3.3.1 |
| `ERROR 1292 (22007): Incorrect datetime value: '2026-02-30' ...` | 日期不存在或格式不对 | 写成 `'YYYY-MM-DD'`，检查日期是否存在 | 3.3.3 |
| `ERROR 1366 (HY000): Incorrect integer value: 'abc' ...` | 给数字列插入了文字 | 检查值和列的对应关系 | 3.3 |
| `ERROR 3819 (HY000): Check constraint 'product_chk_1' is violated.` | 违反 CHECK 约束（如售价必须大于 0） | 改正数据 | 3.4.2 |
| `ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails ...` | 外键值在被参照表里不存在 | 先插入被参照的行，或改正外键值 | 2.4、3.4.4 |
| `ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails ...` | 要删除的行还被别的表引用 | 先处理引用它的行，或设置参照动作 | 3.4.4 |

**权限、连接和并发**

| 报错 | 常见原因 | 解决办法 | 见 |
|---|---|---|---|
| `ERROR 1045 (28000): Access denied for user 'clerk'@'localhost' (using password: YES)` | 用户名或口令错，或该主机不允许登录 | 核对口令；忘记 root 口令见 B.5 | 10.4.1 |
| `ERROR 1142 (42000): UPDATE command denied to user 'clerk'@'localhost' for table 'product'` | 没有这张表的这种权限 | 请管理员授权，或换有权限的账号 | 10.4.2 |
| `ERROR 1143 (42000): SELECT command denied ... for column 'phone' in table 'customer'` | 只授予了部分列的权限 | 只查有权限的列 | 10.4.2 |
| `ERROR 3118 (HY000): Access denied for user 'clerk'@'localhost'. Account is locked.` | 账号被锁定 | 管理员执行 `ALTER USER ... ACCOUNT UNLOCK` | 10.4.4 |
| `ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction` | 要改的行被另一个没提交的事务锁住，等待超时 | 让另一个会话提交或回滚；事务尽量短 | 9.2.4 |

**客户端（DBeaver、Python）**

| 现象 | 原因 | 解决办法 |
|---|---|---|
| DBeaver 提示 `Public Key Retrieval is not allowed` | MySQL 8 默认认证方式需要客户端取公钥 | 连接设置 →“驱动属性”中把 `allowPublicKeyRetrieval` 设为 `true` |
| DBeaver 提示 `Communications link failure` | 服务没启动或端口不对 | “服务”里启动 MySQL84；核对端口 |
| 导入后中文变成问号 | 没按 UTF-8 读入脚本 | 用 DBeaver 打开脚本执行；命令行加 `--default-character-set=utf8mb4` |
| Python 报 `RuntimeError: 'cryptography' package is required` | MySQL 8 默认认证方式需要这个库 | `pip install cryptography` |
| Python 报 `ModuleNotFoundError: No module named 'pymysql'` | 库装到了另一个 Python 里 | 用 `python -m pip install pymysql` |

## 参考文献

<div class="refs" markdown>

- <span id="refB-1"></span>[1] Oracle. MySQL 8.4 Reference Manual: How to Reset the Root Password[EB/OL]. [2026-11-01]. https://dev.mysql.com/doc/refman/8.4/en/resetting-permissions.html.
    <span class="ref-note">Windows 和 Unix 上重置 root 口令的官方步骤（--init-file 方法），对应 B.5 节。</span>
- <span id="refB-2"></span>[2] Oracle. MySQL 8.4 Error Reference: Server Error Message Reference[EB/OL]. [2026-11-01]. https://dev.mysql.com/doc/mysql-errors/8.4/en/server-error-reference.html.
    <span class="ref-note">MySQL 服务器全部错误号、SQLSTATE 和说明，对应 B.6 节。</span>

</div>
