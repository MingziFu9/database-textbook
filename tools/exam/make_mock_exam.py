"""生成附录 F 期末闭卷模拟卷：选择、判断、简答从各章课后练习中抽取，填空、SQL 编写、设计题在 new_items.md 中手写。

用法：python tools/exam/make_mock_exam.py   （改了各章课后练习或 new_items.md 后重新运行）
"""
import re, pathlib
ROOT = pathlib.Path(__file__).resolve().parents[2]
CH = sorted((ROOT / "docs/chapters").glob("[0-9][0-9]-*/index.md"))

def items(ch):
    p = CH[ch - 1]; slug = p.parent.name
    t = p.read_text(encoding="utf-8"); t = t[t.index("\n## 课后练习"):]
    m = re.search(r"\n## ", t[5:]); t = t[:m.start() + 5] if m else t
    secs = re.split(r"\n\*\*([一二三四五六七八]、[^*]+)\*\*\n", t)
    out = {}
    for k in range(1, len(secs), 2):
        body = secs[k + 1]
        parts = re.split(r'\n(?=<div class="quiz)', body) if '<div class="quiz' in body else re.split(r"\n(?=\*\*\d+\.\*\*)", body)
        out[secs[k][2:]] = [fix(x.strip(), slug) for x in parts if x.strip() and (x.lstrip().startswith("<div") or x.lstrip().startswith("**"))]
    return out

def fix(s, slug):
    s = re.sub(r"\]\(#", f"](../chapters/{slug}/index.md#", s)
    s = s.replace("](../../", "](../")
    return s

def renum(s, n):
    return re.sub(r"\*\*\d+\.\*\*", f"**{n}.**", s, count=1)

PICK = {
    1: {"单项选择题": [(1,0),(2,1),(3,0),(3,3),(4,0),(4,4),(5,1),(5,5),(6,2),(7,1),(8,0),(8,4),(9,0),(9,3),(10,1),(10,5),(11,0),(11,4),(12,0),(12,3)],
        "多项选择题": [(2,0),(4,0),(5,1),(8,0),(9,1)],
        "判断题": [(1,0),(2,0),(3,0),(4,1),(5,0),(6,1),(7,0),(8,1),(9,0),(10,1)],
        "简答题": [(7,0),(9,1),(12,0)]},
    2: {"单项选择题": [(1,2),(2,3),(3,5),(3,7),(4,2),(4,6),(5,3),(5,7),(6,4),(7,5),(8,2),(8,6),(9,5),(9,7),(10,3),(10,7),(11,2),(11,6),(12,5),(12,7)],
        "多项选择题": [(3,1),(6,0),(7,1),(10,0),(11,1)],
        "判断题": [(3,2),(4,3),(5,2),(6,3),(7,2),(8,3),(9,2),(10,3),(11,0),(12,1)],
        "简答题": [(2,1),(8,0),(10,2)]},
}
HEAD = {"单项选择题": "一、单项选择题**（每题 1 分，共 20 分）", "多项选择题": "二、多项选择题**（每题 2 分，共 10 分。多选、少选、错选均不得分）",
        "判断题": "三、判断题**（每题 1 分，共 10 分）", "简答题": "七、简答题**（每题 6 分，共 18 分）"}

def section(paper, kind, start):
    ex = {c: items(c) for c in range(1, 13)}
    out = [f"**{HEAD[kind]}", ""]
    for i, (c, k) in enumerate(PICK[paper][kind]):
        out += [renum(ex[c][kind][k], start + i), ""]
    return "\n".join(out)

new = (ROOT / "tools/exam/new_items.md").read_text(encoding="utf-8")
def block(name):
    m = re.search(r"<!-- " + name + r" -->\n(.*?)\n<!-- end -->", new, re.S); return m.group(1).strip()

doc = [block("intro"), ""]
for paper, cn in [(1, "一"), (2, "二")]:
    doc += [f"## 模拟卷{cn} {{ #paper{paper} }}", "", section(paper, "单项选择题", 1), section(paper, "多项选择题", 1),
            section(paper, "判断题", 1), block(f"p{paper}-fill"), "", block(f"p{paper}-sql"), "", block(f"p{paper}-design"), "",
            section(paper, "简答题", 1), ""]
(ROOT / "docs/appendix/f-mock-exam.md").write_text("\n".join(doc).rstrip() + "\n", encoding="utf-8")
print("写入 docs/appendix/f-mock-exam.md")
