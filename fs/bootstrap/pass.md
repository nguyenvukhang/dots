First, install gnupg:

```
brew install gnupg
```

import the private key
`gpg --allow-secret-key-import --import private-key.asc`

edit trust settings
`gpg --edit-key <KEY_ID>` (get the KEY_ID from gpg --list-secret-keys)

trust it ultimately
`gpg> trust`

Done. (no further steps required to use the `p` command)
