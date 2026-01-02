for ssh permissions:

Typically you want the permissions to be:

.ssh directory: 700 (drwx------)
public key (.pub file): 644 (-rw-r--r--)
private key (id_rsa): 600 (-rw-------)

lastly your home directory should not be writeable by the group or
others (at most 755 (drwxr-xr-x)).

```sh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/**/*
chmod 644 ~/.ssh/**/*.pub
```
