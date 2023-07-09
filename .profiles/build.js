const { relative, resolve, join, dirname } = require("path");
const { lstatSync, mkdirSync, rmSync } = require("fs");
const { spawnSync } = require("child_process");

const PROJECT_ROOT = resolve(__dirname, "..");

/**
 * @typedef {import("fs").PathLike} Path
 */

/**
 * Asserts that a directory exists at path
 * @param {Path} dirPath
 */
function assertDir(dirPath) {
  if (!lstatSync(dirPath).isDirectory()) {
    throw new Error(`Directory not found: ${result}`);
  }
}

/**
 * @param {Path} src
 * @param {Path} dst
 */
function symlink(src, dst) {
  spawnSync("ln", ["-sf", src, dst]);
}

class Profile {
  /** @param {string} name */
  constructor(name) {
    this.homeDir = join(__dirname, name, "home");
    this.rootDir = join(__dirname, name, "root");
    assertDir(this.homeDir);
    assertDir(this.rootDir);
  }

  /**
   * @param {string} src
   * @param {string} dst
   */
  home(dst, src) {
    src = join(PROJECT_ROOT, src);
    dst = join(this.homeDir, dst);

    assertDir(src);
    mkdirSync(dirname(dst), { recursive: true });
    rmSync(dst, { force: true });

    const rel = relative(dirname(dst), src);
    symlink(rel, dst);
    console.log({ src, dst, rel });
  }
}

const mac = new Profile("mac");
mac.home(".config/git", "@/git");
