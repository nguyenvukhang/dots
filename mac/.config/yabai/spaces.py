#!/usr/bin/env python3

import sys
import json
import subprocess
import os

yabai_cmd = ['yabai', '-m', 'query', '--spaces']

raw_output = subprocess.run(yabai_cmd, stdout=subprocess.PIPE)
human_readable = raw_output.stdout.decode('utf-8')
space_info = json.loads(human_readable)
displays = len(set(map(lambda x: x['display'], space_info)))
print(displays)
spaces = len(space_info)

if displays == 1:
    os.system('yabai -m space --focus 2')
elif displays == 2:
    os.system('yabai -m space --focus 3')
else:
    print('you made it to three display, damn!')
