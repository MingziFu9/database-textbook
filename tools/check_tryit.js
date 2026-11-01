// 逐个运行某章网页里的“试一试”框，打印结果前几行（编写期检查用）。
// 用法：先 mkdocs build -d build/site，再 node tools/check_tryit.js 4   （需要 playwright）
const http = require("http"), fs = require("fs"), path = require("path");
const { chromium } = require("playwright");
const root = path.resolve(__dirname, ".."), site = path.join(root, "build/site");
const n = String(process.argv[2]).padStart(2, "0");
const chapter = fs.readdirSync(path.join(root, "docs/chapters")).find((d) => d.startsWith(n + "-"));
const types = { ".html": "text/html", ".js": "text/javascript", ".css": "text/css", ".wasm": "application/wasm" };
const srv = http.createServer((req, res) => {
  let p = path.join(site, decodeURIComponent(req.url.split("?")[0]));
  if (fs.existsSync(p) && fs.statSync(p).isDirectory()) p = path.join(p, "index.html");
  if (!fs.existsSync(p)) { res.writeHead(404); return res.end(); }
  res.writeHead(200, { "Content-Type": types[path.extname(p)] || "application/octet-stream" });
  fs.createReadStream(p).pipe(res);
}).listen(0, async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto(`http://127.0.0.1:${srv.address().port}/chapters/${chapter}/`);
  const boxes = page.locator("div.sql-try");
  const count = await boxes.count();
  let bad = 0;
  for (let i = 0; i < count; i++) {
    const b = boxes.nth(i);
    await b.locator(".sql-run").click();
    await page.waitForFunction((el) => !el.querySelector(".sql-output").textContent.includes("正在运行"), await b.elementHandle(), { timeout: 20000 });
    const out = await b.locator(".sql-output").innerText();
    const sql = (await b.locator("textarea").inputValue()).split("\n")[0];
    if (out.includes("出错了")) bad++;
    console.log(`--- [${i + 1}] ${sql}\n` + out.split("\n").slice(0, 10).join("\n"));
  }
  console.log(`共 ${count} 个，出错 ${bad} 个`);
  await browser.close(); srv.close();
});
