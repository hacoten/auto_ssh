# ssh auto_login

## Example

### Key Authentication

    #!/bin/sh

    script_dir=`dirname $0`
    cd $script_dir
    source auto_login.sh

    HOSTNAME={HOSTNAME}
    USERNAME={USERNAME}

    grep "Host $HOSTNAME" ~/.ssh/config >/dev/null 2>&1
    if [ "$?" -eq 1 ]
    then

    cat << _EOF >> ~/.ssh/config

    Host $HOSTNAME
        User $USERNAME
        Hostname $HOSTNAME
        IdentityFile {PRIVATE_KEY_FILE}
        Port 22
    _EOF
    fi

    ssh $HOSTNAME

### Password Authentication

    #!/bin/sh

    script_dir=`dirname $0`
    cd $script_dir
    source auto_login.sh

    # ssh login
    auto_ssh {HOSTNAME} {USERNAME} {PASSWORD}

## Other
* Copy Password
* Character code specified