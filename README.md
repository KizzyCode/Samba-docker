[![License BSD-2-Clause](https://img.shields.io/badge/License-BSD--2--Clause-blue.svg)](https://opensource.org/licenses/BSD-2-Clause)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

# `samba`
Welcome to `samba` 🎉

`samba` is a tiny samba-server-container - nothing special here.


## `samba-adduser`
To provide an easy way to add users, there is an additional `samba-adduser`-helper script. This script edit
`/etc/passwd` directly, so it's possible to use an external persistent `passwd`-file and overlay-mount it into the
container.


## Example
See the [Docker-Compose.yml](Docker-Compose.yml) file as example. The login credentials are `testuser:testuser`.
