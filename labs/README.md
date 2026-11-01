# 《数据库基础与应用》实验代码

按章存放，`chNN/` 对应第 NN 章，每章的 `README.md` 列出文件、用途和编者实测情况。文件名为 `labN_M_英文短名.sql` 或 `.py`（第 N 章实验 N-M）。公共数据放在 `data/`，见 `data/README.md`。

## 准备环境

1. **数据库**（二选一，见教材附录 B）：
    - 直接安装 MySQL 8.4 LTS 和 DBeaver 社区版（第 1 章实验 1-2）；
    - 已会用 Docker 的，在 `docker/` 目录下运行 `docker compose up -d`，同时得到 MySQL 8.4（root / shop123）和带 pgvector 的 PostgreSQL 17（postgres / shop123）。
2. **导入小店示例库**：在 DBeaver 或命令行中执行 `data/shop_mysql.sql`，得到 shop 库（8 张表）。PostgreSQL 用 `data/shop_postgres.sql`（第 10、12 章）。
3. **Python**（只有第 1、11、12 章用到，Python 3.11 及以上，编者用 3.13）：

```bash
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

## 怎样运行

- `.sql` 文件：在 DBeaver 中打开，选中要执行的语句按 Ctrl+Enter（整个脚本按 Alt+X）；或在命令行 `mysql -u root -p shop < 文件名.sql`。每个文件开头的注释写明要在哪个库里运行；
- `.py` 文件：按文件开头注释写的位置和命令运行（如 `python ch01/lab1_3_excel_vs_sql.py`），第 11 章先改好 `ch11/db_config.ini` 里的账号口令；
- 书中的运行结果都是编者在 MySQL 8.4.13、PostgreSQL 17 + pgvector 0.8.7、Python 3.13 上实际运行得到的。唯一例外是 `ch12/lab12_2_chroma_bge.py`（需要下载 bge-small-zh-v1.5 模型，编者环境下载不到），标为“待实测”，教材里留有记录表。

## 还原数据

实验会修改数据。想回到初始状态，重新执行 `data/shop_mysql.sql` 即可（它会先删除再重建 shop 库）。第 9 章的实验在 txshop 练习库里做，运行 `ch09/lab9_0_setup.sql` 还原。
