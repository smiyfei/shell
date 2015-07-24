# keychain 解决pub不存在时可以继续使用

diff /usr/bin/keychain /usr/bin/keychain.new
943,944c943,947
<                               warn "Cannot find public key for $1."
<                               return 1
---
>                               ########for lost pub key########
>                               warn "Cannot find public key for $1 ."
>                               basename "$sf_filename"
>                               return 0
>                               ########/for lost pub key########

