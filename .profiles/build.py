from os import path
import os
import subprocess


def join(*args):
    return path.normpath(path.join(*args))


def pcall(fn):
    try:
        fn()
    except:
        pass


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
        src, dst = self.src, self.dst
        return "{%s -> %s}" % (src, dst)

    def __repr__(self):
        return str(self)

    def execute(self):
        rel = path.relpath(self.src, path.dirname(self.dst))

        pcall(lambda: os.remove(self.dst))
        pcall(lambda: os.makedirs(path.dirname(self.dst), exist_ok=True))
        os.symlink(rel, self.dst)


class Profile:
    def __init__(self, name):  # type: (str) -> None
        self.home_dir = join(SCRIPT_DIR, name, "home")  # type: str
        self.root_dir = join(SCRIPT_DIR, name, "root")  # type: str
        self.links = list([])  # type: list[Link]

    def __str__(self):
        home = tild(self.home_dir)
        root = tild(self.root_dir)
        return "{\n\thome: '%s',\n\troot: '%s'\n}" % (home, root)

    def add(self, dst, src):  # type: (str, str) -> None
        full_dst = path.expanduser(dst)
        if not path.isabs(full_dst):
            msg = 'Invalid path: "%s"\n' % (dst)
            msg += "Paths should start with '~' or '/'"
            raise Exception(msg)
        base_dir = self.home_dir if HOME in full_dst else self.root_dir
        rel_dst = dst.split("/", 1)[1]
        dst = join(base_dir, rel_dst)
        src = join(PROJECT_ROOT, src)
        self.links.append(Link(src, dst))


def sh(*args):
    # sh("rm", "gold")
    subprocess.run(args)


# print(Link(".config/git", "@/git"))

mac = Profile("mac")
mac.add("~/.config/git", "@/git")
mac.add("~/.config/zsh", "zsh")
mac.add("~/.config/tmux", "tmux")
mac.add("~/.config/nvim", "nvim")
mac.add("~/.config/alacritty", "@/alacritty")
mac.add("/etc/zshenv", "zsh/zshenv/mac")

print(mac.links)

for link in mac.links:
    link.execute()
