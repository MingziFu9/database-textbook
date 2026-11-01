# 第 11 章 用 Python 开发数据库应用：实验代码

运行前：① `pip install pymysql cryptography sqlalchemy pandas matplotlib streamlit`；② 用 root 运行一次 `lab11_0_setup.sql`（建程序专用账号 shopapp）；③ 检查 `db_config.ini` 里的主机和端口。所有程序都在本目录下运行。

| 文件 | 用途 |
|---|---|
| lab11_0_setup.sql | 建账号 shopapp 并授权，建 monthly_report 表 |
| db_config.ini | 连接配置（实验用；正式项目不要把这个文件上传） |
| shopdb.py | 读配置、建 PyMySQL 连接和 SQLAlchemy 引擎 |
| lab11_1_pymysql.py | 实验 11-1：查询、DictCursor、事务下单 |
| lab11_1_injection.py | 实验 11-1：拼接与参数化对比 |
| lab11_2_sales_analysis.py | 实验 11-2：窗口函数 + pandas 月度分析，生成 monthly_sales.png |
| shop_service.py | 实验 11-3：业务层函数 |
| lab11_3_app.py | 实验 11-3：Streamlit 界面，运行 `streamlit run lab11_3_app.py` |

实验 11-2、11-3 需要第 8 章的视图：先运行 `labs/ch08/lab8_1_views.sql`。
编者环境：Python 3.13、PyMySQL 1.2.3、SQLAlchemy 2.1.6、pandas 3.1.0、matplotlib 3.11.2、Streamlit 1.66.1。
