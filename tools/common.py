"""各工具共用的小函数：读取 course.yml、定位章节和附录、解析 Markdown 头部信息。"""
import re
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
DOCS = ROOT / "docs"
CHAPTERS = DOCS / "chapters"
BUILD = ROOT / "build"        # 课件、教案、Word/PDF 和渲染出的配图都输出到这里（不提交到仓库）
LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


def course():
    c = yaml.safe_load((ROOT / "course.yml").read_text(encoding="utf-8"))
    c.setdefault("certificates", [])
    c.setdefault("lesson_plan", {})
    c.setdefault("lab_section", "本章实验")
    c.setdefault("lab_word", "实验")
    c.setdefault("frontier_title", "前沿视窗")
    for i, ch in enumerate(c["chapters"], 1):
        ch["num"] = i
        ch.setdefault("short", ch["title"])
        ch.setdefault("labs", c.get("labs_per_chapter", 0))
        ch.setdefault("theory", 0)
        ch.setdefault("lab", 0)
    for i, ap in enumerate(c.get("appendices", [])):
        ap["letter"] = LETTERS[i]
    return c


def site_url(c):
    return f"https://{c['github_user'].lower()}.github.io/{c['repo']}/"


def chapter_path(ch):
    return CHAPTERS / ch["dir"] / "index.md"


def safe_name(s):
    """去掉文件名里不能用的字符"""
    return re.sub(r'[\\/:*?"<>|]', "", s)


def chapter_heading(ch):
    return f"第 {ch['num']} 章 {ch['title']}"


def chapter_by_num(num, c=None):
    c = c or course()
    for ch in c["chapters"]:
        if ch["num"] == int(num):
            return ch
    raise SystemExit(f"course.yml 里没有第 {num} 章")


def front_matter(text):
    """返回 (头部字典, 正文)。"""
    m = re.match(r"---\n(.*?)\n---\n", text, re.S)
    if not m:
        return {}, text
    return yaml.safe_load(m.group(1)) or {}, text[m.end():]


def section(text, title, next_level=2):
    """取出某个二级标题下的内容（到下一个同级标题为止）。"""
    m = re.search(rf"^## {re.escape(title)}[^\n]*\n(.*?)(?=^#{{1,{next_level}}} |\Z)", text, re.S | re.M)
    return m.group(1) if m else ""


def replace_between(text, start, end, block):
    """把 start 和 end 两个标记之间的内容换成 block；标记不存在时返回 None。"""
    if start not in text or end not in text:
        return None
    return text[:text.index(start) + len(start)] + "\n" + block.strip("\n") + "\n" + text[text.index(end):]


# ---------- 读章节内容（课件、教案、导出共用） ----------

def chapter_text(ch):
    return front_matter(chapter_path(ch).read_text(encoding="utf-8"))[1]


def plain(s):
    """去掉 Markdown 行内标记，只留文字：链接、术语链接、文献上标、属性、HTML 标签。"""
    s = re.sub(r'<sup class="cite">.*?</sup>', "", s)
    s = re.sub(r"\[([^\]]+)\]\([^)]*\)(\{[^}]*\})?", r"\1", s)
    s = re.sub(r"\{ *[.#:a-z][^}]*\}", "", s)
    s = re.sub(r"<[^>]+>", "", s)
    return s.strip()


def headings(text, level):
    """返回 [(标题, 内容), ...]，内容到下一个同级或更高级标题为止。代码块里的 # 不算标题。"""
    out, cur, buf, fence = [], None, [], False
    for line in text.split("\n"):
        if line.startswith("```"):
            fence = not fence
        m = None if fence else re.match(r"^(#{1,6}) (.*?)(?:\s*\{ *#[^}]*\})?$", line)   # 去掉显式锚点 { #116 }
        if m and len(m.group(1)) <= level:
            if cur is not None:
                out.append((cur, "\n".join(buf)))
            cur, buf = (m.group(2).strip() if len(m.group(1)) == level else None), []
            continue
        buf.append(line)
    if cur is not None:
        out.append((cur, "\n".join(buf)))
    return out


def list_items(block, indent=0):
    """Markdown 列表中缩进为 indent 的各项（去掉“- ”“1. ”），保留行内标记。"""
    pad = " " * indent
    return [m.group(1).strip() for m in re.finditer(rf"^{pad}(?:[-*]|\d+\.) +(.*)$", block, re.M)]


def admonition(text, kind, title_prefix=""):
    """取出 !!! kind "标题..." 提示框（或 ??? 折叠框）的正文，返回 [(标题, 正文), ...]。"""
    out = []
    for m in re.finditer(rf'^(?:!!!|\?\?\?\+?) {kind}(?: "({re.escape(title_prefix)}[^"]*)")?\n((?:    .*\n|\n)+)', text + "\n", re.M):
        body = "\n".join(l[4:] for l in m.group(2).split("\n")).strip()
        out.append((m.group(1) or "", body))
    return out


def sims_in(text):
    """正文里嵌入的交互动画：[(动画文件夹名, 标题), ...]"""
    return re.findall(r'<iframe class="sim-frame" src="[^"]*sims/([\w-]+)/main\.html"[^>]*title="([^"]*)"', text)


def mermaid_blocks(text):
    return re.findall(r"^```mermaid\n(.*?)^```", text, re.S | re.M)


def parse_quizzes(text):
    """课后练习里可在线作答的题：[{kind: 单选/多选/判断, stem, options, answer, explain, ref}, ...]"""
    tail = text[text.index("## 课后练习"):] if "## 课后练习" in text else ""
    out = []
    pat = r'<div class="quiz([^"]*)" data-answer="([^"]+)" markdown>\n((?:(?!</div>)[\s\S])*?)\n</div>\s*\n\?\?\? tip "答案与解析"\n((?:    [^\n]*\n|\n)+)'
    for m in re.finditer(pat, tail + "\n"):
        cls, answer, body, exp = m.groups()
        kind = "多选" if "quiz-multi" in cls else "判断" if "quiz-judge" in cls else "单选"
        stem = " ".join(l.strip() for l in body.split("\n") if l.strip() and not re.match(r"^\s*- ", l))
        stem = re.sub(r"^\*\*\d+\.\*\* *", "", stem)
        options = [re.sub(r"^- ", "", l.strip()) for l in body.split("\n") if re.match(r"^\s*- ", l)]
        exp_lines = [l[4:] for l in exp.split("\n")]
        ref = re.search(r"\[回看 ?([^\]]+)\]", exp)
        explain = " ".join(l.strip() for l in exp_lines
                           if l.strip() and not l.startswith("**答案") and not l.startswith("考查") and "{ .quiz-meta }" not in l)
        out.append({"kind": kind, "stem": plain(stem), "options": [plain(o) for o in options], "answer": answer,
                    "explain": plain(explain), "ref": ref.group(1) if ref else ""})
    return out


def other_exercises(text):
    """简答题、实操题等不能在线作答的题：[(题型, 题干), ...]"""
    tail = text[text.index("## 课后练习"):] if "## 课后练习" in text else ""
    out = []
    for part in re.split(r"\n\*\*[一二三四五六七八]、", tail)[1:]:
        kind = part.split("**", 1)[0]
        if "选择" in kind or "判断" in kind:
            continue
        for m in re.finditer(r"^\*\*\d+\.\*\* *(.+)$", part, re.M):
            out.append((kind, plain(m.group(1))))
    return out


def lab_list(text, word="实验"):
    """本章实验 / 体验：[(编号, 标题, 目的列表), ...]"""
    out = []
    for title, body in headings(text, 3):
        m = re.match(rf"^(?:实验|体验|{word}) (\d+-\d+) *(.*)$", title)
        if m:
            goal = re.search(r"目的\*\*\n\n((?:\d+\..*\n?)+)", body)
            out.append((m.group(1), m.group(2), [plain(x) for x in list_items(goal.group(1))] if goal else []))
    return out


# ---------- 配图（由 tools/render_figures.mjs 渲染） ----------

def mermaid_png(code):
    import hashlib
    p = BUILD / "figures/mermaid" / (hashlib.sha1(code.strip().encode("utf-8")).hexdigest()[:12] + ".png")
    return p if p.exists() else None


def sim_png(name):
    p = BUILD / "figures/sims" / f"{name}.png"
    return p if p.exists() else None


def qr_png(url):
    """网址的二维码图片（需要 qrcode 库），返回文件路径；没装库时返回 None。"""
    try:
        import qrcode
    except ImportError:
        return None
    import hashlib
    p = BUILD / "figures/qr" / (hashlib.sha1(url.encode("utf-8")).hexdigest()[:12] + ".png")
    if not p.exists():
        p.parent.mkdir(parents=True, exist_ok=True)
        qrcode.make(url, border=1).save(p)
    return p
