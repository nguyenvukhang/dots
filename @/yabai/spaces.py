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

def get_destination(n, current_display):
    local_spaces = dwm[current_display]
    local_first = local_spaces[0]
    if n <= len(local_spaces):
        return local_spaces[n-local_first]
    else:
        return 0


def main():
    if len(argv) != 3: return

    first_arg = int(argv[1])
    if first_arg == 0: return

    second_arg = argv[2]

    target = get_destination(first_arg, current_display)
    if target == 0: return

    print('target', target)
    if second_arg == '--focus':
        # handle focus
        os.system('yabai -m space --focus %s' % (target))
    elif second_arg == '--move':
        # handle move
        os.system('yabai -m window --space %s' % (target))

main()
