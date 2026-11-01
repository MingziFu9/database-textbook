/* 网页“试一试”：在浏览器里运行 SQL（sql.js = 编译成 WebAssembly 的 SQLite，本地托管，不连外网）。
 * 写法（Markdown）：
 *   <div class="sql-try" markdown>          默认载入“社区小店”示例库
 *   <div class="sql-try" data-db="empty" markdown>   空数据库（练习建表）
 *   ```sql
 *   SELECT * FROM product LIMIT 5;
 *   ```
 *   </div>
 * 为了少出现“网页能跑、MySQL 不能跑”的情况，这里给 SQLite 补了常用的 MySQL 函数：
 * YEAR、MONTH、DAY、HOUR、DATE_FORMAT、CONCAT、IF、LEFT、RIGHT、DATEDIFF、CURDATE、NOW、CHAR_LENGTH。
 */
(function () {
  const me = document.currentScript && document.currentScript.src;
  const base = me ? me.replace(/[^/]*$/, "") : "javascripts/";
  let sqlPromise = null;
  let dbBytes = null;

  function loadSql() {
    if (!sqlPromise) {
      sqlPromise = new Promise((resolve, reject) => {
        const s = document.createElement("script");
        s.src = base + "sqljs/sql-wasm.js";
        s.onload = () => initSqlJs({ locateFile: (f) => base + "sqljs/" + f }).then(resolve, reject);
        s.onerror = () => reject(new Error("没能载入 sql-wasm.js"));
        document.head.appendChild(s);
      });
    }
    return sqlPromise;
  }

  async function loadShop() {
    if (!dbBytes) {
      const r = await fetch(base + "../tryit/shop.sqlite");
      if (!r.ok) throw new Error("没能载入示例数据库（" + r.status + "）");
      dbBytes = new Uint8Array(await r.arrayBuffer());
    }
    return dbBytes;
  }

  const pad = (n) => String(n).padStart(2, "0");
  const toDate = (v) => {
    if (v === null || v === undefined) return null;
    const d = new Date(String(v).replace(" ", "T"));
    return isNaN(d) ? null : d;
  };
  function addMysqlFunctions(db) {
    const f = (name, fn) => db.create_function(name, fn);
    f("YEAR", (d) => (toDate(d) ? toDate(d).getFullYear() : null));
    f("MONTH", (d) => (toDate(d) ? toDate(d).getMonth() + 1 : null));
    f("DAY", (d) => (toDate(d) ? toDate(d).getDate() : null));
    f("HOUR", (d) => (toDate(d) ? toDate(d).getHours() : null));
    f("DATE_FORMAT", (d, fmt) => {
      const t = toDate(d);
      if (!t) return null;
      return String(fmt).replace(/%([YmdHisy])/g, (_, c) => ({
        Y: t.getFullYear(), y: String(t.getFullYear()).slice(2), m: pad(t.getMonth() + 1), d: pad(t.getDate()),
        H: pad(t.getHours()), i: pad(t.getMinutes()), s: pad(t.getSeconds()) }[c]));
    });
    const cat = (...a) => (a.some((x) => x === null) ? null : a.join(""));
    f("CONCAT", (a, b) => cat(a, b));
    db.create_function("CONCAT", function (a, b, c) { return cat(a, b, c); });
    db.create_function("CONCAT", function (a, b, c, d) { return cat(a, b, c, d); });
    db.create_function("CONCAT", function (a, b, c, d, e) { return cat(a, b, c, d, e); });
    f("IF", (c, a, b) => (c ? a : b));
    f("LEFT", (s, n) => (s === null ? null : String(s).slice(0, n)));
    f("RIGHT", (s, n) => (s === null ? null : String(s).slice(-n)));
    f("CHAR_LENGTH", (s) => (s === null ? null : [...String(s)].length));
    f("DATEDIFF", (a, b) => {
      const x = toDate(String(a).slice(0, 10)), y = toDate(String(b).slice(0, 10));
      return x && y ? Math.round((x - y) / 86400000) : null;
    });
    const today = () => { const t = new Date(); return t.getFullYear() + "-" + pad(t.getMonth() + 1) + "-" + pad(t.getDate()); };
    db.create_function("CURDATE", function () { return today(); });
    db.create_function("NOW", function () { const t = new Date(); return today() + " " + pad(t.getHours()) + ":" + pad(t.getMinutes()) + ":" + pad(t.getSeconds()); });
  }

  function esc(s) {
    return String(s).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]));
  }

  function renderResult(res, out, changed) {
    out.innerHTML = "";
    if (!res.length) {
      out.innerHTML = '<div class="sql-ok">执行成功' + (changed ? "，影响了 " + changed + " 行" : "（这条语句没有返回结果表）") + "。</div>";
      return;
    }
    res.forEach((r) => {
      const max = 100;
      let h = '<div class="sql-table-wrap"><table class="sql-table"><thead><tr>' +
        r.columns.map((c) => "<th>" + esc(c) + "</th>").join("") + "</tr></thead><tbody>";
      r.values.slice(0, max).forEach((row) => {
        h += "<tr>" + row.map((v) => (v === null ? '<td class="sql-null">NULL</td>' : "<td>" + esc(v) + "</td>")).join("") + "</tr>";
      });
      h += "</tbody></table></div><div class=\"sql-count\">共 " + r.values.length + " 行" +
        (r.values.length > max ? "，只显示前 " + max + " 行" : "") + "</div>";
      out.insertAdjacentHTML("beforeend", h);
    });
  }

  function setup(box) {
    const code = box.querySelector("pre code") || box.querySelector("pre");
    if (!code) return;
    const original = code.textContent.replace(/\s+$/, "");
    const kind = box.dataset.db || "shop";
    const area = document.createElement("textarea");
    area.className = "sql-editor";
    area.spellcheck = false;
    area.value = original;
    area.rows = Math.min(14, Math.max(3, original.split("\n").length + 1));
    const bar = document.createElement("div");
    bar.className = "sql-bar";
    bar.innerHTML = '<button type="button" class="sql-run">▶ 运行</button>' +
      '<button type="button" class="sql-reset">恢复原样</button>' +
      '<span class="sql-tip">' + (kind === "empty" ? "空数据库，" : "社区小店示例库，") + "改了随便试，刷新网页就还原（网页里运行的是 SQLite）</span>";
    const out = document.createElement("div");
    out.className = "sql-output";
    const holder = box.querySelector(".highlight") || code.closest("pre");
    holder.replaceWith(area);
    area.after(bar);
    bar.after(out);
    let db = null;
    async function getDb() {
      if (db) return db;
      const SQL = await loadSql();
      db = kind === "empty" ? new SQL.Database() : new SQL.Database(await loadShop());
      addMysqlFunctions(db);
      db.run("PRAGMA foreign_keys = ON;");
      return db;
    }
    bar.querySelector(".sql-run").addEventListener("click", async () => {
      out.innerHTML = '<div class="sql-ok">正在运行……</div>';
      try {
        const d = await getDb();
        const res = d.exec(area.value);
        renderResult(res, out, d.getRowsModified());
      } catch (e) {
        out.innerHTML = '<div class="sql-err">出错了：' + esc(e.message) + "</div>";
      }
    });
    bar.querySelector(".sql-reset").addEventListener("click", () => {
      area.value = original;
      if (db) { db.close(); db = null; }
      out.innerHTML = "";
    });
    area.addEventListener("keydown", (e) => {
      if ((e.ctrlKey || e.metaKey) && e.key === "Enter") bar.querySelector(".sql-run").click();
    });
  }

  function init() { document.querySelectorAll("div.sql-try").forEach(setup); }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", init);
  else init();
})();
