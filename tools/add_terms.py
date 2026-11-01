"""把一章的术语写进附录 D 术语表（编写期辅助脚本）。

用法：python tools/add_terms.py 3 terms.tsv
terms.tsv 每行：术语<TAB>英文<TAB>定义<TAB>例子。已存在的术语会被替换，表内其他行保留。
写完再运行 python tools/glossary_links.py anchors / link N / concepts N。
"""
import re
import sys
from pathlib import Path

G = Path(__file__).resolve().parent.parent / "docs/appendix/glossary.md"


def main():
    n = int(sys.argv[1])
    rows = [l.rstrip("\n").split("\t") for l in Path(sys.argv[2]).read_text(encoding="utf-8").splitlines() if l.strip()]
    text = G.read_text(encoding="utf-8")
    m = re.search(rf"(## 第 {n} 章[^\n]*\n\n\| 术语 \| 英文 \| 定义 \| 例子 \|\n\|---\|---\|---\|---\|\n)((?:\|.*\n)*)", text)
    if not m:
        sys.exit(f"术语表里没有第 {n} 章小节")
    old = [l for l in m.group(2).splitlines() if l.strip()]
    names = {r[0] for r in rows}
    keep = [l for l in old if re.sub(r"<span[^>]*></span>", "", l.strip("|").split("|")[0]).strip() not in names
            and "示例术语" not in l and "另一个术语" not in l]
    new = keep + [f"| {t} | {e} | {d} | {x} |" for t, e, d, x in rows]
    text = text[:m.start(2)] + "\n".join(new) + "\n" + text[m.end(2):]
    G.write_text(text, encoding="utf-8")
    print(f"第 {n} 章术语 {len(new)} 条")


if __name__ == "__main__":
    main()
