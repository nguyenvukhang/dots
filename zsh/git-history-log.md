Editing dates

```sh
#!/bin/sh
# vim:ft=bash

TIME='10:28:01'
DATE='26 Jun 2023'
TMZN='+0800'
MESSAGE='submit deferral for reservist'

COMMIT=acc77e1

CURRENT=$(git rev-parse HEAD)

git reset --hard $COMMIT >/dev/null
git commit --allow-empty --amend --no-edit --date="$TIME $DATE $TMZN" -m "$MESSAGE" >/dev/null
git cherry-pick --allow-empty $COMMIT..$CURRENT >/dev/null
```
