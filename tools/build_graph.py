"""由概念表（concepts-draft.csv）和附录 D 术语表生成学习图谱 data.js。

用法：python tools/build_graph.py && python tools/graph_text.py
节点 = 术语表全部术语；先修关系取自概念表（概念名按 ALIAS 对应到术语名，
不在术语表里的概念把它的先修关系传下去），术语表里有、概念表里没有的术语用 EXTRA 补先修。
"""
import csv
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import glossary_links as g  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
LG = ROOT / "docs/learning-graph"
CATS = [("FOUND", "基础概念"), ("PD", "Python 与 pandas"), ("COLL", "数据采集"), ("CLEAN", "数据清洗"),
        ("LABEL", "数据标注"), ("STAT", "统计分析"), ("VIS", "可视化与报告"), ("MODEL", "建模应用"),
        ("REC", "推荐系统"), ("OPS", "系统运维"), ("ETH", "伦理与合规")]
ALIAS = {"用户-物品矩阵": ["用户—物品矩阵"], "PSI": ["群体稳定性指标"], "数据脱敏": ["脱敏"], "最小必要原则": ["最小必要"],
         "API": ["应用程序接口"], "SQL 查询": ["SQL"], "关系数据库": ["数据库"], "JSON 展平": ["展平"],
         "训练集与测试集": ["训练集", "测试集"], "精确率与召回率": ["精确率", "召回率"], "金标准数据": ["金标准"],
         "抽样检验": ["抽检"], "验收标准": ["验收"], "标签噪声": ["噪声标签"], "总体与样本": ["总体", "样本"],
         "抽样方法": ["随机抽样"], "交互式图表": ["交互图表"], "召回与排序": ["召回", "排序"], "推荐评估": ["离线评估"],
         "系统运维": ["智能系统运维"], "错误案例分析": ["错误分析"], "清洗流水线": ["数据处理流水线"],
         "scikit-learn 流水线": ["流水线"], "网页采集": ["网络爬虫"], "文本分类标注": ["文本分类"],
         "图像分割标注": ["图像分割"], "指标体系": ["指标"], "回归模型": ["回归"], "分类模型": ["分类", "逻辑回归"],
         "柱状图": ["条形图"]}
EXTRA = {  # 术语: (先修, 类别)
    "变量": ([], "PD"), "列表": (["变量"], "PD"), "字典": (["变量"], "PD"), "函数": (["变量"], "PD"),
    "库": (["函数"], "PD"), "DataFrame": (["库", "结构化数据"], "PD"), "日期时间类型": (["数据类型"], "PD"),
    "UTF-8": (["文件编码"], "COLL"), "GBK": (["文件编码"], "COLL"), "乱码": (["UTF-8", "GBK"], "COLL"),
    "展平": (["JSON"], "COLL"), "数据库": (["数据源"], "COLL"), "SQL": (["数据库"], "COLL"), "SQLite": (["数据库"], "COLL"),
    "应用程序接口": (["数据源"], "COLL"), "HTTP 请求": (["应用程序接口"], "COLL"), "重试": (["HTTP 请求", "状态码"], "COLL"),
    "网络爬虫": (["HTTP 请求"], "COLL"), "robots 协议": (["网络爬虫"], "COLL"), "采集方案": (["数据采集", "数据源"], "COLL"),
    "数据质量维度": (["数据质量"], "CLEAN"), "中位数": (["缺失值"], "CLEAN"), "按组填充": (["缺失值", "分组聚合"], "CLEAN"),
    "脱敏": (["正则表达式"], "CLEAN"), "无效评论": (["业务规则校验"], "CLEAN"), "数据处理流水线": (["函数", "清洗规范"], "CLEAN"),
    "监督学习": (["训练数据"], "LABEL"), "标签": (["监督学习"], "LABEL"), "数据标注": (["标签"], "LABEL"),
    "偏好数据": (["数据标注"], "LABEL"), "文本分类": (["数据标注"], "LABEL"), "图像分割": (["目标框标注"], "LABEL"),
    "试标": (["标注规范"], "LABEL"), "金标准": (["标注规范"], "LABEL"), "Fleiss' Kappa": (["Kappa 系数"], "LABEL"),
    "验收": (["标注准确率"], "LABEL"), "抽检": (["分层抽样"], "LABEL"), "抽检方案": (["抽检", "分层抽样"], "LABEL"),
    "错误分析": (["抽检"], "LABEL"), "噪声标签": (["标注准确率"], "LABEL"),
    "众数": (["集中趋势"], "STAT"), "标准差": (["离散程度"], "STAT"), "相关矩阵": (["相关系数"], "STAT"),
    "总体": (["描述统计"], "STAT"), "样本": (["总体"], "STAT"), "随机抽样": (["样本"], "STAT"), "指标": (["描述统计"], "STAT"),
    "条形图": (["数据可视化"], "VIS"), "堆叠柱状图": (["条形图"], "VIS"), "子图": (["Matplotlib"], "VIS"),
    "数据透视图": (["透视表", "数据可视化"], "VIS"), "商业智能": (["数据看板"], "VIS"), "截断纵轴": (["误导性图表"], "VIS"),
    "双纵轴": (["误导性图表"], "VIS"), "交互图表": (["数据可视化"], "VIS"), "指标卡": (["数据看板", "指标"], "VIS"),
    "机器学习": (["训练数据", "监督学习"], "MODEL"), "模型": (["机器学习"], "MODEL"), "回归": (["监督学习", "模型"], "MODEL"),
    "分类": (["监督学习", "模型"], "MODEL"), "训练集": (["模型"], "MODEL"), "测试集": (["训练集"], "MODEL"),
    "过拟合": (["训练集", "测试集"], "MODEL"), "scikit-learn": (["库", "机器学习"], "MODEL"),
    "流水线": (["scikit-learn"], "MODEL"), "标准化": (["特征", "标准差"], "MODEL"),
    "平均绝对误差": (["回归"], "MODEL"), "决定系数": (["回归"], "MODEL"), "残差": (["回归"], "MODEL"),
    "TF-IDF": (["特征", "文本分类"], "MODEL"), "逻辑回归": (["分类"], "MODEL"), "精确率": (["混淆矩阵"], "MODEL"),
    "召回率": (["混淆矩阵"], "MODEL"), "K 均值": (["聚类"], "MODEL"), "提示词": (["预训练模型"], "MODEL"),
    "用户—物品矩阵": (["推荐系统", "透视表"], "REC"), "稀疏": (["用户—物品矩阵"], "REC"),
    "杰卡德相似度": (["基于内容的推荐"], "REC"), "召回": (["推荐系统"], "REC"), "排序": (["召回"], "REC"),
    "离线评估": (["推荐系统", "测试集"], "REC"),
    "智能系统运维": (["在线服务"], "OPS"), "灰度发布": (["在线服务"], "OPS"), "延迟": (["监控指标"], "OPS"),
    "P95 延迟": (["延迟", "分位数"], "OPS"), "错误率": (["监控指标"], "OPS"), "群体稳定性指标": (["数据漂移", "分布"], "OPS"),
    "归因": (["坏案例"], "OPS"),
    "最小必要": (["个人信息"], "ETH"), "掩码": (["脱敏"], "ETH"), "哈希": (["脱敏"], "ETH"), "泛化": (["脱敏"], "ETH"),
    "扰动": (["脱敏"], "ETH"), "准标识符": (["个人信息"], "ETH"), "去标识化": (["掩码", "哈希", "准标识符"], "ETH"),
    "隐私计算": (["去标识化"], "ETH")}
EXTRA_EDGES = [("掩码", "匿名化"), ("泛化", "匿名化"), ("随机抽样", "样本偏差"), ("结构化数据", "数据字典"), ("虚拟环境", "Jupyter"), ("Jupyter", "变量")]


def main():
    G = g.parse()
    terms = {t: (ch, a, d) for ch, lst in G.items() for t, a, d in lst}
    rows = list(csv.DictReader(open(LG / "concepts-draft.csv", encoding="utf-8")))
    byid = {r["ConceptID"]: r for r in rows}
    code = [c for c, _ in CATS]

    def resolve(cid, seen=()):
        r = byid[cid]
        name = r["ConceptLabel"]
        if name in terms:
            return [name]
        if name in ALIAS:
            return ALIAS[name]
        out = []                                      # 不在术语表里：把它的先修传下去
        for d in filter(None, r["Dependencies"].split("|")):
            if d not in seen:
                out += resolve(d, seen + (cid,))
        return out

    cat, edges = {}, []
    for r in rows:
        for t in resolve(r["ConceptID"]) if (r["ConceptLabel"] in terms or r["ConceptLabel"] in ALIAS) else []:
            cat.setdefault(t, r["TaxonomyID"])
            for d in filter(None, r["Dependencies"].split("|")):
                for p in resolve(d):
                    edges.append((p, t))
    for t, (pre, c) in EXTRA.items():
        cat[t] = c
        edges += [(p, t) for p in pre]
    edges += EXTRA_EDGES
    # 去掉自环、重复、指向更早章节的边（后续概念不能出现在先修概念之前的章）
    seen, E = set(), []
    for a, b in edges:
        if a == b or (a, b) in seen or a not in terms or b not in terms:
            continue
        if terms[a][0] > terms[b][0]:
            continue
        seen.add((a, b)); E.append([a, b])
    nodes = []
    for ch, lst in sorted(G.items()):
        for t, a, d in lst:
            nodes.append({"id": t, "ch": ch, "cat": code.index(cat.get(t, "FOUND")), "a": a, "d": d})
    old = (LG / "data.js").read_text(encoding="utf-8")
    head = old[:old.index("var NODES")]
    head = head.replace(head[head.index("var CATS"):head.index(";", head.index("var CATS")) + 1],
                        "var CATS = " + json.dumps([n for _, n in CATS], ensure_ascii=False) + ";")
    body = "var NODES = [\n" + ",\n".join("  " + json.dumps(n, ensure_ascii=False) for n in nodes) + "\n];\n"
    body += "var EDGES = " + json.dumps(E, ensure_ascii=False) + ";\n"
    (LG / "data.js").write_text(head + body, encoding="utf-8")
    nocat = [t for t in terms if t not in cat]
    print(f"节点 {len(nodes)}，先修关系 {len(E)}；没有分类的术语（按基础概念）：{nocat}")
    orphan = [n["id"] for n in nodes if not any(n["id"] in e for e in E)]
    print("孤立节点：", orphan)


main()
