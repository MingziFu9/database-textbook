# 第 10 章 数据库管理：安装配置、权限、备份与安全：实验代码

| 文件 | 用途 | 用哪个账号运行 |
|---|---|---|
| lab10_1_accounts.sql | 实验 10-1：建三个角色和三个账号并授权 | root |
| lab10_1_test_clerk.sql | 实验 10-1：店员能做什么、不能做什么 | clerk / Clerk#2026 |
| lab10_1_test_accountant.sql | 实验 10-1：会计能做什么、不能做什么 | accountant / Acct#2026 |
| lab10_1_revoke.sql | 实验 10-1：收回权限、锁定账号 | root |
| lab10_1_masked_view.sql | 10.6.3：手机号脱敏视图 | root |
| lab10_2_check.sql | 实验 10-2：备份前、恢复后核对行数和销售额 | root |
| lab10_2_after_backup.sql | 实验 10-2：备份之后新增一单 | root |
| lab10_3_mysql.sql / lab10_3_postgres.sql | 实验 10-3：两种数据库写法对照 | root / postgres |

实验 10-1 需要先运行 `labs/ch08/lab8_1_views.sql` 建好视图 v_monthly_sales。
实验 10-2 会删除 shop 库，万一恢复失败，运行 `labs/data/shop_mysql.sql` 重建。
