#!/bin/sh
set -euo pipefail

# Create user
if ! getent passwd "$SMB_USER" >/dev/null; then
    # Create user and set password
    echo "Creating user $SMB_USER"
    adduser -S -H -D -u 1000 -s /sbin/nologin "$SMB_USER"

    # Create config
    export SMB_LOGLEVEL=${SMB_LOGLEVEL:-1}
    cat /etc/samba/smb.conf.template | envsubst > /etc/samba/smb.conf

    # Set the SMB password
    if test -z "$SMB_PASS"; then
        echo "Missing \$SMB_PASS"
        exit 1
    fi
    echo -e "$SMB_PASS\n$SMB_PASS" | smbpasswd -L -a -c /etc/samba/smb.conf "$SMB_USER"
fi

# Start supervisor
exec supervisord -c "/etc/samba/supervisord.conf"
