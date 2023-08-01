const { readFileSync, lstatSync, readdirSync } = require("fs");
const { join } = require("path");

const avgLL = 40;

const sum = (a) => a.reduce((a, b) => a + b);
const pad = (n) => `      ${n}`.slice(-5);
const inspect = (v) => {
  console.log(v);
  return v;
};

/** Gets all files recursively under a specified directory */
const getAllFiles = (root) => {
  /** @type {[string[], boolean]} */
  const [a, d] = [[], (v) => lstatSync(v).isDirectory()];
  const l = (c) => readdirSync(c).map((v) => join(c, v));
  const r = (c) => l(c).forEach((f) => (d(f) ? r(f) : a.push(f)));
  r(root);
  return a.filter((v) => v !== root);
};

const useLine = (line) =>
  line.trim().length > 0 && !line.trimStart().startsWith("--");

const useFile = (file) =>
  file.endsWith(".lua") && !file.includes("gruvbox") && !file.includes("test");

/**
 * Removes lua comments denoted by `--`
 * @param {string} raw line
 * @returns {string} processed line
 */
const cleanLine = (line) => {
  line = line.trim();
  if (!line.includes("--")) return line;
  const stack = [];
  for (let i = 0; i < line.length; i++) {
    const c = line.charAt(i);
    const q = c == "'" || c == '"';
    if (q) {
      if (stack.length == 0 || stack[stack.length - 1] !== c) stack.push(c);
      else if (stack[stack.length - 1] === c) stack.pop();
    }
    if (line.slice(i, i + 2) === "--" && stack.length == 0)
      return line.slice(0, i);
  }
  return line;
};

const lua = getAllFiles(__dirname)
  .filter(useFile)
  .map((f) => ({
    filename: f.slice(__dirname.length + 1),
    lines: readFileSync(f, "utf8").split("\n").filter(useLine).map(cleanLine),
  }))
  .map(({ filename, lines }) => ({
    estd: Math.round(lines.reduce((a, c) => a + c.length, 0) / avgLL),
    chars: lines.reduce((a, c) => a + c.length, 0),
    real: lines.length,
    filename,
  }));

const realTotal = sum(lua.map((v) => v.real));
const estLines = sum(lua.map((v) => v.chars)) / avgLL;

lua.sort((a, b) => a.estd - b.estd);
lua.forEach((v) => console.log(pad(v.real), pad(v.estd), v.filename));
console.log("real total:", realTotal);
console.log("Using average line length of", avgLL, ",");
console.log("There is about", Math.round(estLines), "lines of code");
