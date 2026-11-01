"""第 11 章公用代码：从 db_config.ini 读配置并连接数据库。"""
import configparser
from pathlib import Path

import pymysql

CONFIG_FILE = Path(__file__).with_name("db_config.ini")


def read_config():
    """读取配置文件里 [mysql] 一节，返回一个字典。"""
    cfg = configparser.ConfigParser()
    cfg.read(CONFIG_FILE, encoding="utf-8")
    c = cfg["mysql"]
    return {"host": c["host"], "port": int(c["port"]), "user": c["user"],
            "password": c["password"], "database": c["database"]}


def get_connection(dict_rows=False):
    """返回一个 PyMySQL 连接；dict_rows=True 时每行结果是字典。"""
    cursor_class = pymysql.cursors.DictCursor if dict_rows else pymysql.cursors.Cursor
    return pymysql.connect(**read_config(), charset="utf8mb4", cursorclass=cursor_class)


def get_engine():
    """返回 SQLAlchemy 引擎，给 pandas 的 read_sql / to_sql 使用。"""
    from urllib.parse import quote_plus
    from sqlalchemy import create_engine
    c = read_config()
    url = (f"mysql+pymysql://{c['user']}:{quote_plus(c['password'])}"
           f"@{c['host']}:{c['port']}/{c['database']}?charset=utf8mb4")
    return create_engine(url)
