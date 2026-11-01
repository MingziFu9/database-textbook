"""统计全书各章的字数、实验、练习、术语、参考文献和交互动画，写入首页“全书概览”表格。

用法：python tools/book_stats.py   （可重复运行；表格写在首页两个 stats 注释之间）
"""
import re
from pathlib import Path

import glossary_links as g
from common import course

ROOT = Path(__file__).resolve().parent.parent
DOCS = ROOT / "docs"
START, END = "<!-- stats:start -->", "<!-- stats:end -->"


def chapter_stats(path, num, glossary):
    s = path.read_text(encoding="utf-8")
    body = s[:s.index("## 课后练习")]
    body = re.sub(r"```.*?```", "", body, flags=re.S)          # 不算代码
    body = re.sub(r"<[^>]+>|\]\([^)]*\)", "", body)              # 不算 HTML 标签和链接网址
    tail = s[s.index("## 课后练习"):]
    exercises = sum(len(re.findall(r"^\*\*\d+\.\*\*", part, re.M)) for part in re.split(r"\n\*\*[一二三四五六七八]、", tail)[1:])
    return {
        "num": num, "dir": path.parent.name,
        "words": len(re.findall(r"[一-鿿]", body)),
        "labs": len(re.findall(r"^### (?:实验|体验) \d+-\d+", s, re.M)),   # 导论用“体验 N-M”
        "exercises": exercises,
        "quiz": len(re.findall(r'class="quiz[ "]', tail)),
        "terms": len(glossary.get(num, [])),
        "refs": len(re.findall(rf'<span id="ref{num}-\d+"></span>', s)),
        "sims": s.count('class="sim-frame"'),
    }


def wan(n):
    return f"{n / 10000:.1f} 万"


def main():
    glossary = g.parse()
    # 还在编写、没有“课后练习”的章不计入统计
    chapters = [p for p in sorted((DOCS / "chapters").glob("*/index.md")) if "## 课后练习" in p.read_text(encoding="utf-8")]
    rows = [chapter_stats(p, int(p.parent.name[:2]), glossary) for p in chapters]
    total = {k: sum(r[k] for r in rows) for k in ("words", "labs", "exercises", "quiz", "terms", "refs", "sims")}
    graph = (DOCS / "learning-graph/data.js").read_text(encoding="utf-8")
    concepts = graph.count('"id":')
    faq = (DOCS / "faq/index.md").read_text(encoding="utf-8").count('??? question')
    word = course().get("lab_word", "实验")
    lines = [START, "", f"| 章 | 正文字数 | {word} | 课后练习<br>（可在线作答） | 术语 | 参考文献 | 交互动画 |", "|---|---|---|---|---|---|---|"]
    for r in rows:
        lines.append(f"| [第 {r['num']} 章](chapters/{r['dir']}/index.md) | {wan(r['words'])} | {r['labs']} | {r['exercises']}（{r['quiz']}） | {r['terms']} | {r['refs']} | {r['sims']} |")
    lines.append(f"| **合计** | **{wan(total['words'])}** | **{total['labs']}** | **{total['exercises']}（{total['quiz']}）** | **{total['terms']}** | **{total['refs']}** | **{total['sims']}** |")
    lines += ["", f"正文字数只统计汉字，不含代码和课后练习；单选、多选和判断题可以在网页上直接作答。配套学习资源：[交互动画](sims/index.md) {total['sims']} 个 · [学习图谱](learning-graph/index.md) {concepts} 个概念 · [常见问题](faq/index.md) {faq} 问 · [术语表](appendix/glossary.md) {total['terms']} 条。", "", END]
    index = DOCS / "index.md"
    s = index.read_text(encoding="utf-8")
    block = "\n".join(lines)
    if START in s:
        s = s[:s.index(START)] + block + s[s.index(END) + len(END):]
    else:
        s = s.replace("## 目录与实验", "## 全书概览\n\n" + block + "\n\n## 目录与实验", 1)
    index.write_text(s, encoding="utf-8")
    print(f"全书 {wan(total['words'])}字，{total['labs']} 个{word}，{total['exercises']} 道练习，{total['sims']} 个动画")


if __name__ == "__main__":
    main()
