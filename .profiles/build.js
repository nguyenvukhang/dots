const { relative, resolve, join } = require("path");
const { lstatSync } = require("fs");

/**
 * @typedef {import("fs").PathLike} Path
 */

/**
 * Asserts that a directory exists at path
 * @param {Path} path
 */
function assertDir(dirPath) {
  if (!lstatSync(dirPath).isDirectory()) {
    throw new Error(`Directory not found: ${result}`);
  }
}

const PROJECT_ROOT = resolve(__dirname, "..");

class Profile {
  /** @param {string} name */
  constructor(name) {
    this.homeDir = join(__dirname, name, "home");
    this.rootDir = join(__dirname, name, "root");
    assertDir(this.homeDir)
    assertDir(this.rootDir)
  }

  /**
   * @param {string} src
   * @param {string} dst
   */
  home(dst, src) {
    src = join(PROJECT_ROOT, src);
    dst = join(this.homeDir, dst);

    assertDir(src)
    // don't assertDir on destination because it doesn't need to exist

    console.log({ src, dst });
    console.log(relative(dst, src));
  }
}

const mac = new Profile("mac");
mac.home(".config/git", "@/git");
