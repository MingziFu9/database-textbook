// 学习图谱数据：由编者整理，概念与定义取自附录 D 术语表
// 改完后运行 python tools/graph_text.py，检查数据并更新 index.md 里的文字版
var CATS = ["示例类别一", "示例类别二"];
var CHAPTERS = ["", "概述", "关系模型", "建表与增删改", "单表查询", "多表查询", "E-R 设计", "范式", "视图与索引", "事务与存储过程", "数据库管理", "Python 应用开发", "向量数据库"];
var CHDIRS = ["", "01-overview", "02-relational-model", "03-sql-ddl-dml", "04-single-table-query", "05-multi-table-query", "06-er-design", "07-normalization", "08-view-index", "09-transaction", "10-administration", "11-python-app", "12-vector-db"];
var NODES = [
  {"id": "示例术语", "ch": 1, "cat": 0, "a": "g-示例术语", "d": "这里是术语表中的定义，鼠标悬停时显示"},
  {"id": "另一个术语", "ch": 1, "cat": 1, "a": "g-另一个术语", "d": "以示例术语为基础的概念"}
];
var EDGES = [["示例术语", "另一个术语"]];
