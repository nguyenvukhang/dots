from os import path
import os
import subprocess


def join(*args):
    return path.normpath(path.join(*args))


SCRIPT_DIR = path.dirname(__file__)
PROJECT_ROOT = join(SCRIPT_DIR, "..")
HOME = path.expanduser("~")


def tild(path):  # type: (str) -> str
    return path.replace(HOME, "~")


class Link:
    def __init__(self, src, dst):  # type: (str, str) -> None
        self.src = src
        self.dst = dst

    def __str__(self):
        src = tild(self.src)
        dst = tild(self.dst)
        return "{%s -> %s}" % (src, dst)

    def __repr__(self):
        return str(self)

    def execute(self):
        rel = path.relpath(self.src, path.dirname(self.dst))

        try:
            os.remove(self.dst)
        except:
            pass
        os.symlink(rel, self.dst)


class Profile:
    def __init__(self, name):  # type: (str) -> None
        self.home_dir = join(SCRIPT_DIR, name, "home")
        self.root_dir = join(SCRIPT_DIR, name, "root")
        self.links = list([])  # type: list[Link]

    def __str__(self):
        home = tild(self.home_dir)
        root = tild(self.root_dir)
        return "{\n\thome: '%s',\n\troot: '%s'\n}" % (home, root)

    def add(self, base, src, dst):  # type: (str, str, str) -> None
        if dst.startswith("/"):
            dst = dst[1:]
        dst = join(base, dst)
        src = join(PROJECT_ROOT, src)
        self.links.append(Link(src, dst))

    def home(self, dst, src):
        self.add(self.home_dir, src, dst)

    def root(self, dst, src):
        self.add(self.root_dir, src, dst)


def sh(*args):
    # sh("rm", "gold")
    subprocess.run(args)


# print(Link(".config/git", "@/git"))

mac = Profile("mac")
mac.home(".config/git", "@/git")
mac.home(".config/zsh", "zsh")
mac.home(".config/tmux", "tmux")
mac.home(".config/nvim", "nvim")
mac.home(".config/alacritty", "@/alacritty")
mac.root("/etc/zshenv", "zsh/zshenv/mac")

print(mac.links)

for link in mac.links:
    link.execute()
