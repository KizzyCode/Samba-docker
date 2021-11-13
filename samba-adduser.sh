#!/bin/sh
set -eu

# Get the username
USERNAME="${1:-}"
if test -z "$USERNAME"; then
    echo "!> Invalid empty username"
    echo "   Usage: $0 username"
    exit 1
fi


# Ensure that the user does not exist already
if getent passwd "$USERNAME" >/dev/null; then
    echo "User $USERNAME exists already"
    exit 1
fi


# Read user password
echo -n "?> Enter password: " 1>&2
read -s PASSWORD_1
echo
echo -n "?> Retype password: " 1>&2
read -s PASSWORD_2
echo

if test "$PASSWORD_1" != "$PASSWORD_2"; then
    echo "!> Passwords do not match"
    exit 1
fi


# Determine UID
UID=""
for _UID in `seq 1000 65535`; do
    if ! getent passwd "$_UID" >/dev/null; then
        UID=$_UID
        break
    fi
done

if test -z "$UID"; then
    echo "!> Failed to determine unused UID"
    exit 1
fi


# Determine GID
GID=`getent group nogroup | cut -d":" -f"3" || echo ""`
if test -z "$GID"; then
    echo "!> Failed to determine GID for nogroup"
    exit 1
fi


# Add the system user to the userdb
if test -n "`tail -c 1 /etc/passwd`"; then
    echo "" >> /etc/passwd
fi
echo "$USERNAME:x:$UID:$GID:sambauser:/:/sbin/nologin" >> /etc/passwd

if test -n "`tail -c 1 /etc/shadow`"; then
    echo "" >> /etc/shadow
fi
echo "$USERNAME:!::0:::::" >> /etc/shadow


# Set the SMB password
smbpasswd -a -n "$USERNAME" >/dev/null
echo -e "$PASSWORD_1\n$PASSWORD_2" | smbpasswd "$USERNAME" >/dev/null
