Editing dates

```sh
#!/bin/sh
# vim:ft=bash

COMMIT=88c36a3
TIME='12:14:14'
DATE='26 Jun 2023'
TMZN='+0800'
# MESSAGE=''
DATE="$TIME $DATE $TMZN"

CURRENT=$(git rev-parse HEAD)

git reset --hard $COMMIT

if [[ -z $MESSAGE ]]; then
  GIT_COMMITTER_DATE="$DATE" \
    git commit --allow-empty --amend --no-edit --date="$DATE"
else
  GIT_COMMITTER_DATE="$DATE" \
    git commit --allow-empty --amend --no-edit --date="$DATE" -m "$MESSAGE"
fi

git cherry-pick --allow-empty $COMMIT..$CURRENT
```
