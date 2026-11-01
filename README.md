# 数据库基础与应用（网络教材）

面向成人教育人工智能技术应用专业（专科）的《数据库基础与应用》网络教材，课程代码 2619，5 学分 90 学时（线上理论 54 + 线上实验 18 + 线下理论 18），第 2 学期，期末闭卷。

网页版：<https://mingzifu9.github.io/database-textbook/>

## 内容

跟着“社区小店”从一张 Excel 表格起步，一章往前走一步，主线用 MySQL 8.4 + DBeaver：

| 章 | 标题 |
|---|---|
| 1 | 数据库概述 |
| 2 | 关系模型：用表格描述世界 |
| 3 | SQL 入门：建库、建表与增删改 |
| 4 | 单表查询与分组统计 |
| 5 | 多表查询：连接与子查询 |
| 6 | 数据库设计：从需求到 E-R 图 |
| 7 | 规范化与范式 |
| 8 | 视图、索引与查询优化 |
| 9 | 事务、存储过程与触发器 |
| 10 | 数据库管理：安装配置、权限、备份与安全（对照 PostgreSQL） |
| 11 | 用 Python 开发数据库应用 |
| 12 | 向量数据库原理（Chroma、pgvector、RAG 检索） |

每章含学习目标、情景导入、正文（第 1～5 章等配有可在网页上运行 SQL 的“试一试”框）、前沿视窗、3 个实验（2 个基础 ★、1 个拓展 ☆）、小结、23 道课后练习（单选、多选、判断可在线作答）和参考文献。另有 14 个交互动画、附录 A～F（SQL 速查、实验环境与报错速查、示例库说明、术语表、设计文档模板、两套闭卷模拟卷）、常见问题、学习图谱和全国计算机等级考试二级 MySQL 考点对照。

## 目录结构

| 路径 | 内容 |
|---|---|
| `course.yml` | 课程配置：书名、学时、章节、附录。改完运行 `python tools/course.py sync` |
| `docs/chapters/` | 12 章正文 |
| `docs/sims/` | 交互动画（每个文件夹一个，`common/` 是公共样式和脚本） |
| `docs/tryit/`、`docs/javascripts/tryit.js`、`docs/javascripts/sqljs/` | 网页“试一试”：浏览器里的 SQLite（sql.js）和小店示例库 |
| `docs/appendix/` | 附录 A～F |
| `docs/learning-graph/` | 学习图谱（由 `tools/build_graph.py` 根据术语表和先修关系生成） |
| `docs/faq/`、`docs/certificate.md` | 常见问题、证书考点对照 |
| `labs/` | 实验 SQL 和 Python 程序、示例库数据、Docker 配置，见 `labs/README.md` |
| `slides/`、`lesson-plans/` | 每章课件底稿（`chNN.md`）和教案底稿（`chNN.yml`） |
| `tools/` | 维护脚本；`tools/exam/` 生成附录 F 模拟卷 |
| `.github/workflows/pages.yml` | 推送到 `main` 后自动发布网页 |
| `.github/workflows/exports.yml` | 手动运行，在 GitHub 上生成课件、教案和 Word/PDF 版 |

## 本地预览

```bash
pip install -r requirements-docs.txt
mkdocs serve          # 浏览器打开 http://127.0.0.1:8000
```

## 维护脚本

```bash
python tools/course.py sync                # 按 course.yml 更新导航、首页、章节骨架、动画目录等
python tools/glossary_links.py anchors     # 给术语表每个术语加锚点
python tools/glossary_links.py concepts 03 # 生成第 3 章的“本章概念清单”
python tools/build_graph.py                # 由术语表生成学习图谱数据
python tools/graph_text.py                 # 检查学习图谱并生成文字版
python tools/book_stats.py                 # 更新首页“全书概览”统计表
python tools/exam/make_mock_exam.py        # 重新生成附录 F 两套模拟卷
python tools/check_anchors.py              # 检查全站链接和锚点（先 mkdocs build）
node tools/check_tryit.js 4                # 检查第 4 章“试一试”框里的 SQL 都能运行
```

## 课件、教案和 Word/PDF 版

```bash
pip install -r requirements-tools.txt
npm install && npx playwright install chromium
npm run figures                            # 把 Mermaid 图和交互动画渲染成图片

python tools/make_slides.py build all      # → build/课件/第NN章 章名.pptx
python tools/make_lesson_plan.py build all # → build/教案/第NN章 章名 教案.docx
python tools/export_docx.py --pdf          # → build/数据库基础与应用.docx 和 .pdf（需要 pandoc 和 LibreOffice）
```

## 关于实验结果

- 示例库 shop 由 `labs/data/make_shop_db.py` 用固定随机种子生成，内容为虚构；重新生成会得到完全相同的数据，正文里的行数、金额都以它为准。
- SQL 结果是编者在 MySQL 8.4.13 和 PostgreSQL 17 + pgvector 0.8.7（`labs/docker/` 的 Docker 环境）上实际运行得到的，Python 程序用 Python 3.13 运行。
- 唯一的“待实测”是实验 12-2 第二部分（bge-small-zh-v1.5 语义搜索）：编写环境下载不到模型，程序流程已检查，教材里附有记录表，请任课教师在能访问 Hugging Face 或魔搭的机房先跑一遍。
