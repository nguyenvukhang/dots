import os
import subprocess

def sh(*args):
    subprocess.run(args)

sh("rm", "gold")

