const { relative, resolve, join, dirname } = require("path");
const { lstatSync, mkdirSync, rmSync } = require("fs");
const { spawnSync } = require("child_process");

const PROJECT_ROOT = resolve(__dirname, "..");

class Link {
  constructor(src, dst) {
    this.src = src;
    this.dst = dst;
  }

  execute() {
    rmSync(this.dst, { force: true });
    mkdirSync(dirname(this.dst), { recursive: true });
    const rel = relative(dirname(this.dst), this.src);
    spawnSync("ln", ["-sf", rel, this.dst]);
  }
}

/**
 * @typedef {import("fs").PathLike} Path
 */

/**
 * Asserts that a directory exists at path
 * @param {Path} path
 */
function assertExists(path) {
  lstatSync(path);
}

class Profile {
  /** @param {string} name */
  constructor(name) {
    this.homeDir = join(__dirname, name, "home");
    this.rootDir = join(__dirname, name, "root");
    this.links = [];
    assertExists(this.homeDir);
    assertExists(this.rootDir);
  }

  home(dst, src) {
    this.add(this.homeDir, dst, src);
  }

  root(dst, src) {
    this.add(this.rootDir, dst, src);
  }

  /**
   * @param {string} src
   * @param {string} dst
   */
  add(baseDir, dst, src) {
    src = join(PROJECT_ROOT, src);
    assertExists(src);
    dst = join(baseDir, dst);
    this.links.push(new Link(src, dst));
  }

  linkAll() {
    this.links.forEach((v) => v.execute());
  }
}

const mac = new Profile("mac");
mac.home(".config/git", "@/git");
mac.home(".config/zsh", "zsh");
mac.home(".config/tmux", "tmux");
mac.home(".config/nvim", "nvim");
mac.home(".config/alacritty", "@/alacritty");
mac.root("/etc/zshenv", "zsh/zshenv/mac");

mac.linkAll();
console.log(mac.links);
