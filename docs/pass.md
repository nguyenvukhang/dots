## .password-store setup

Install `gnupg`

```sh
brew install gnupg   # MacOS
sudo pacman -S gnupg # ArchBTW
```

Setup the key

```sh
gpg --allow-secret-key-import --import udon.key
gpg --list-secret-keys # use this to get KEY_ID
gpg --edit-key KEY_ID  # open gpg's CLI
# gpg> trust
#   ...
#   1 = I don't know or won't say
#   2 = I do NOT trust
#   3 = I trust marginally
#   4 = I trust fully
#   5 = I trust ultimately
#   m = back to the main menu
#
# Your decision? 5
```

Done.

## Generating new keys

Either one of `gpg --default-new-key-algo rsa4096 --gen-key` or
`gpg --full-gen-key` will do.

```sh
gpg --default-new-key-algo rsa4096 --gen-key
gpg --full-gen-key # verisons 2.1.17 or greater
```

At this point, you will have an operational key in your keyring,
accessible through the `gpg` command. To export it, continue with

```sh
gpg --export-secret-keys KEY_ID > udon.key
```

## Migrating ~/.password-store

To migrate the password store to this new key, re-initialize the
store with this key.

```
pass init KEY_ID
```

To maintain validity of other keys, do:

```
pass init KEY_ID1 KEY_ID2 ...
```
