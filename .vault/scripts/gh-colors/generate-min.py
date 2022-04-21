#!/usr/bin/env python3

import json
import yaml

def pprint(obj):
    # create a formatted string of the Python JSON object
    text = json.dumps(obj, sort_keys=True, indent=4)
    print(text)

res = {}

with open('languages.yml') as f:
  data = yaml.safe_load(f)
  for i in data:
      res[i] = {}
      try:
          res[i]["color"] = data[i]["color"]
      except:
          res[i]["color"] = None

with open('min.json', "w") as f:
    json.dump(res, f)
