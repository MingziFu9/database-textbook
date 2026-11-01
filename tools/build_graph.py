"""由附录 D 术语表和下面的先修关系表生成学习图谱 data.js。

用法：python tools/build_graph.py && python tools/graph_text.py
节点 = 术语表全部术语（定义、所在章取自术语表）；先修关系 PRE 由编者按各章内容整理，每个概念只写最直接的 1～3 个先修。
"""
import json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CATS = ["基本概念", "SQL 语言", "数据库设计", "索引与事务", "管理与安全", "应用开发", "向量数据库"]
CHCAT = {1: 0, 2: 0, 3: 1, 4: 1, 5: 1, 6: 2, 7: 2, 8: 3, 9: 3, 10: 4, 11: 5, 12: 6}
PRE = {
    "数据库管理系统": "数据库", "数据库系统": "数据库 数据库管理系统", "模式": "数据库", "外模式": "模式", "内模式": "模式",
    "数据独立性": "外模式 内模式", "关系型数据库": "数据库管理系统", "SQL": "关系型数据库", "MySQL": "关系型数据库",
    "PostgreSQL": "关系型数据库", "SQLite": "关系型数据库", "NoSQL": "关系型数据库", "向量数据库": "NoSQL",
    "Text-to-SQL": "SQL",
    "数据模型": "数据库", "关系模型": "数据模型", "关系": "关系模型", "元组": "关系", "属性": "关系", "域": "属性",
    "关系模式": "关系 属性", "超键": "属性 元组", "候选键": "超键", "主键": "候选键", "外键": "主键",
    "完整性约束": "关系模型", "实体完整性": "主键 完整性约束", "参照完整性": "外键 完整性约束", "用户定义完整性": "完整性约束",
    "关系代数": "关系", "选择": "关系代数", "投影": "关系代数", "连接": "关系代数 外键",
    "声明式语言": "SQL", "DDL": "SQL", "DML": "SQL", "DQL": "SQL", "DCL": "SQL", "字符集": "DDL", "数据类型": "DDL 域",
    "非空约束": "完整性约束 DDL", "唯一约束": "候选键 DDL", "默认值": "DDL", "检查约束": "用户定义完整性 DDL",
    "查询": "DQL", "别名": "查询", "DISTINCT": "查询", "通配符": "查询", "分页": "查询", "CASE 表达式": "查询",
    "聚合函数": "查询", "分组": "聚合函数", "HAVING": "分组", "执行顺序": "HAVING 别名",
    "笛卡尔积": "连接", "表别名": "别名", "内连接": "连接 表别名", "外连接": "内连接", "自连接": "内连接 表别名",
    "子查询": "查询", "EXISTS": "子查询", "相关子查询": "子查询", "派生表": "子查询 表别名", "UNION": "查询",
    "公用表表达式": "派生表",
    "数据库设计": "关系模型", "需求分析": "数据库设计", "数据字典": "需求分析", "概念设计": "需求分析",
    "实体": "概念设计", "联系": "实体", "多对多联系": "联系", "E-R 图": "实体 联系", "逻辑设计": "E-R 图 关系模式",
    "中间表": "多对多联系 外键", "物理设计": "逻辑设计 数据类型",
    "数据冗余": "关系模式", "异常": "数据冗余", "函数依赖": "属性", "部分依赖": "函数依赖 候选键", "传递依赖": "函数依赖",
    "范式": "函数依赖 异常", "规范化": "范式 部分依赖 传递依赖", "BC 范式": "规范化", "反规范化": "规范化",
    "视图": "查询", "全表扫描": "查询", "索引": "全表扫描", "B+ 树": "索引", "聚簇索引": "B+ 树 主键",
    "二级索引": "聚簇索引", "组合索引": "索引", "最左前缀": "组合索引", "执行计划": "索引", "慢查询日志": "执行计划",
    "事务": "DML", "提交": "事务", "回滚": "事务", "ACID": "提交 回滚", "并发": "事务", "脏读": "并发 提交",
    "不可重复读": "并发", "幻读": "并发", "隔离级别": "脏读 不可重复读 幻读", "锁": "并发",
    "存储过程": "DML", "存储函数": "存储过程", "触发器": "存储过程", "事件": "存储过程",
    "用户账号": "DCL", "权限": "用户账号", "角色": "权限", "最小权限原则": "权限", "备份": "数据库",
    "恢复": "备份", "逻辑备份": "备份", "增量备份": "备份", "二进制日志": "增量备份", "时间点恢复": "二进制日志 恢复",
    "SQL 注入": "SQL", "数据加密": "用户账号", "数据脱敏": "视图 权限",
    "数据库驱动": "MySQL", "数据库连接": "数据库驱动", "游标": "数据库连接", "参数化查询": "游标 SQL 注入",
    "窗口函数": "分组", "数据挖掘": "窗口函数", "ORM": "数据库连接",
    "嵌入": "向量数据库", "嵌入模型": "嵌入", "余弦相似度": "嵌入", "欧氏距离": "嵌入", "内积": "余弦相似度",
    "最近邻搜索": "余弦相似度 欧氏距离", "近似最近邻": "最近邻搜索 索引", "召回率": "近似最近邻", "HNSW": "近似最近邻",
    "元数据过滤": "最近邻搜索", "pgvector": "PostgreSQL HNSW", "检索增强生成": "嵌入模型 最近邻搜索",
    "混合检索": "检索增强生成 通配符",
}


def terms():
    ch, out = 0, []
    for line in (ROOT / "docs/appendix/glossary.md").read_text(encoding="utf-8").splitlines():
        m = re.match(r"## 第 (\d+) 章", line)
        if m:
            ch = int(m.group(1)); continue
        m = re.match(r'\| <span id="(g-[^"]+)"></span>([^|]+)\| ([^|]*)\| ([^|]*)\|', line)
        if m:
            out.append({"id": m.group(2).strip(), "ch": ch, "cat": CHCAT[ch], "a": m.group(1), "d": m.group(4).strip()})
    return out


def main():
    T = terms(); names = {t["id"] for t in T}
    E = []
    for b, pre in PRE.items():
        assert b in names, b
        toks, i = pre.split(), 0
        while i < len(toks):          # 术语名本身可能带空格（如“E-R 图”），先试两个词连起来
            a = toks[i] + " " + toks[i + 1] if i + 1 < len(toks) and toks[i] + " " + toks[i + 1] in names else toks[i]
            i += 2 if " " in a else 1
            assert a in names, (a, b)
            E.append([a, b])
    old = (ROOT / "docs/learning-graph/data.js").read_text(encoding="utf-8")
    keep = "\n".join(l for l in old.splitlines() if l.startswith("var CHAPTERS") or l.startswith("var CHDIRS"))
    js = ("// 学习图谱数据：由 tools/build_graph.py 根据附录 D 术语表和先修关系生成，请勿手改\n"
          "// 改完后运行 python tools/graph_text.py，检查数据并更新 index.md 里的文字版\n"
          f"var CATS = {json.dumps(CATS, ensure_ascii=False)};\n{keep}\nvar NODES = [\n" +
          ",\n".join("  " + json.dumps(t, ensure_ascii=False) for t in T) + "\n];\nvar EDGES = " +
          json.dumps(E, ensure_ascii=False) + ";\n")
    (ROOT / "docs/learning-graph/data.js").write_text(js, encoding="utf-8")
    print(f"{len(T)} 个概念，{len(E)} 条先修关系")


main()
