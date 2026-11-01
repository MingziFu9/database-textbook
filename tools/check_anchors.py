"""检查站内链接的锚点是否存在（mkdocs --strict 不检查锚点）。先 mkdocs build -d build/site。
用法：python tools/check_anchors.py
"""
import re
from pathlib import Path
from html.parser import HTMLParser
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parent.parent
SITE = ROOT / "build/site"


class Ids(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = set()

    def handle_starttag(self, tag, attrs):
        for k, v in attrs:
            if k == "id":
                self.ids.add(v)


cache = {}


def ids_of(html):
    if html not in cache:
        p = Ids()
        p.feed(html.read_text(encoding="utf-8"))
        cache[html] = p.ids
    return cache[html]


bad = 0
for md in sorted((ROOT / "docs").rglob("*.md")):
    rel = md.relative_to(ROOT / "docs")
    page = SITE / (rel.parent / "index.html" if rel.name == "index.md" else rel.with_suffix("") / "index.html")
    text = md.read_text(encoding="utf-8")
    for m in re.finditer(r"\]\(([^)\s]*?)#([^)\s\"]+)", text):
        target, anchor = m.group(1), unquote(m.group(2))
        if target.startswith("http"):
            continue
        if target == "":
            html = page
        else:
            t = (md.parent / target).resolve()
            trel = t.relative_to((ROOT / "docs").resolve())
            html = SITE / (trel.parent / "index.html" if trel.name == "index.md" else trel.with_suffix("") / "index.html")
        if not html.exists():
            print(f"{rel}: 页面不存在 {target}")
            bad += 1
            continue
        if anchor not in ids_of(html):
            print(f"{rel}: 锚点不存在 {target}#{anchor}")
            bad += 1
print("锚点问题：", bad)
