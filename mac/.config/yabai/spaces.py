#!/usr/bin/env python3

import sys
import json
import subprocess
import os

argv = sys.argv

def get_json(str):
    term_cmd = str.split()
    raw_output = subprocess.run(term_cmd, stdout=subprocess.PIPE)
    human_readable = raw_output.stdout.decode('utf-8')
    return json.loads(human_readable)

spaces = get_json('yabai -m query --spaces')
displays = get_json('yabai -m query --displays')
current_space = get_json('yabai -m query --spaces --space')
current_display = current_space['display']

dwm = {x+1: [] for x in range(len(displays))}

for i in spaces:
    dwm[i['display']].append(i['index'])

print(dwm, current_display)

def get_destination(first_arg, current_display):
    n = int(first_arg)
    local_spaces = dwm[current_display]
    local_first = local_spaces[0]
    if n <= len(local_spaces):
        return local_spaces[n-local_first]
    else:
        return 0

if len(argv) > 1:
    first_arg = argv[1]
    target = get_destination(first_arg, current_display)
    print('target', target)
    if target != 0:
        os.system('yabai -m space --focus %s' % (target))
