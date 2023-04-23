const { readFileSync, lstatSync, readdirSync } = require("fs");
const { join } = require("path");
const avgLL = 40;

/** Gets all files recursively under a specified directory */
const getAllFiles = (root) => {
  const [a, d] = [[], (v) => lstatSync(v).isDirectory()];
  const l = (c) => readdirSync(c).map((v) => join(c, v));
  const r = (c) => l(c).forEach((f) => (d(f) ? r(f) : a.push(f)));
  r(root);
  return a.filter((v) => v !== root);
};

let lineLengths = [];

const lines = (f) => {
  const lines = readFileSync(f, "utf8")
    .split("\n")
    .filter((v) => v.trim().length !== 0)
    .filter((v) => !v.trimStart().startsWith("--"));
  lines.forEach((v) => lineLengths.push(v.trim().length));
  const estd = lines.reduce((a, c) => a + c.length, 0) / avgLL;
  return [lines.length, Math.round(estd)];
};

const pad = (n) => `      ${n}`.slice(-5);
const pre = __dirname.length + 1;
const lua = getAllFiles(__dirname)
  .filter((v) => v.endsWith(".lua"))
  .filter((v) => !v.includes("gruvbox"))
  .map((v) => {
    const [real, estd] = lines(v);
    return { filename: v.slice(pre), real, estd };
  });

lua.sort((a, b) => a.lines - b.lines);
lua.forEach((v) => console.log(pad(v.real), pad(v.estd), v.filename));
console.log(
  "real total:",
  lua.reduce((a, c) => a + c.real, 0)
);
console.log("Using average line length of", avgLL);
const avg = lineLengths.reduce((a, c) => a + c, 0) / avgLL;
console.log("There is about", Math.round(avg), "lines of code");
