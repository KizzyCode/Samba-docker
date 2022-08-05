#!/bin/sh
set -eu

# Create user
if ! getent passwd "$SMB_USER" >/dev/null; then
    # Print status
    echo "Creating user $SMB_USER"
    
    # Determine GID for `nogroup`
    UID=1000
    GID=`getent group nogroup | cut -d":" -f"3" || echo ""`
    if test -z "$GID"; then
        echo "Failed to determine GID for nogroup"
        exit 1
    fi

    # Add the system user to the userdb
    if test -n "`tail -c 1 /etc/passwd`"; then
        echo "" >> /etc/passwd
    fi
    echo "$SMB_USER:x:$UID:$GID:sambauser:/:/sbin/nologin" >> /etc/passwd

    # Set system user password
    if test -n "`tail -c 1 /etc/shadow`"; then
        echo "" >> /etc/shadow
    fi
    echo "$SMB_USER:!::0:::::" >> /etc/shadow

    # Set the SMB password
    if test -z "$SMB_PASS"; then
        echo "Missing \$SMB_PASS"
        exit 1
    fi
    smbpasswd -a -n "$SMB_USER" >/dev/null
    echo -e "$SMB_PASS\n$SMB_PASS" | smbpasswd "$SMB_USER" >/dev/null

    # Create config
    export SMB_LOGLEVEL=${SMB_LOGLEVEL:-1}
    cat /etc/samba/smb.conf.template | envsubst > /etc/samba/smb.conf
fi

# Start supervisor
exec supervisord -c "/etc/samba/supervisord.conf"
