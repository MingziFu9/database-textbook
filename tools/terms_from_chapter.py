"""从第 N 章正文的术语链接里取出“术语 + 定义”，合并英文和例子后写进术语表（编写期辅助脚本）。

用法：python tools/terms_from_chapter.py N extra.tsv
extra.tsv 每行：术语<TAB>英文<TAB>例子
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
n = int(sys.argv[1])
ch = next((ROOT / "docs/chapters").glob(f"{n:02d}-*/index.md")).read_text(encoding="utf-8")
extra = {}
for line in Path(sys.argv[2]).read_text(encoding="utf-8").splitlines():
    if line.strip():
        t, e, x = line.split("\t")
        extra[t] = (e, x)
rows, seen = [], set()
for m in re.finditer(r'\[\*\*(.+?)\*\*\]\(\.\./\.\./appendix/glossary\.md#g-[^ ]+ "([^"]+)"\)\{ \.term \}', ch):
    t, d = m.group(1), m.group(2)
    if t in seen:
        continue
    seen.add(t)
    if t not in extra:
        sys.exit(f"缺英文和例子：{t}")
    rows.append("\t".join([t, extra[t][0], d, extra[t][1]]))
missing = set(extra) - seen
if missing:
    print("提示：extra 里有、正文里没有链接的术语：", missing)
tmp = ROOT / "build/terms.tsv"
tmp.parent.mkdir(exist_ok=True)
tmp.write_text("\n".join(rows) + "\n", encoding="utf-8")
subprocess.run([sys.executable, str(ROOT / "tools/add_terms.py"), str(n), str(tmp)], check=True)
