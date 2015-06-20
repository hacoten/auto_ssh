#!/bin/sh

auto_ssh() {
    host=$1
    id=$2
    pass=$3

    # change encoding
    if which cocot >/dev/null 2>&1 ; then
        if [ "$4" != "" ] ; then
            SSH="cocot -t utf-8 -p $4 ssh"
        else
            SSH="ssh"
        fi
    else
        SSH="ssh"
    fi

    expect -c "
    set timeout 10
    spawn $SSH ${id}@${host}
    expect \"Are you sure you want to continue connecting (yes/no)?\" {
        send \"yes\n\"
        expect \"${id}@${host}'s password:\"
        send \"${pass}\n\"
    } \"${id}@${host}'s password:\" {
        send \"${pass}\n\"
    }
    interact
    "
}

auto_ssh_proxy() {
    proxy_host=$1
    proxy_user=$2
    host=$3
    id=$4
    pass=$5

    SSH_PROXY="ssh -t ${proxy_user}@${proxy_host} "

    # change encoding
    if which cocot >/dev/null 2>&1 ; then
        if [ "$6" != "" ] ; then
            SSH="cocot -t utf-8 -p $6 ssh"
        else
            SSH="ssh"
        fi
    else
        SSH="ssh"
    fi

    expect -c "
    set timeout 10
    spawn $SSH_PROXY \"$SSH ${id}@${host}\"
    expect \"Are you sure you want to continue connecting (yes/no)?\" {
        send \"yes\n\"
        expect \"${id}@${host}'s password:\"
        send \"${pass}\n\"
    } \"${id}@${host}'s password:\" {
        send \"${pass}\n\"
    }
    interact
    "
}

portFoward() {
    local_port=$1
    end_point_host=$2
    end_point_port=$3
    relay_point_user=$4
    relay_point_host=$5
    relay_point_pass=$6

    expect -c "
    set timeout 10
    spawn ssh -L ${local_port}:${end_point_host}:${end_point_port} ${relay_point_user}@${relay_point_host}
    expect \"Are you sure you want to continue connecting (yes/no)?\" {
        send \"yes\n\"
        expect \"${relay_point_user}@${relay_point_host}'s password:\"
        send \"${relay_point_pass}\n\"
    } \"${relay_point_user}@${relay_point_host}'s password:\" {
        send \"${relay_point_pass}\n\"
    }
    interact
    "
}

portFoward_nopass() {
    local_port=$1
    end_point_host=$2
    end_point_port=$3
    relay_point_user=$4
    relay_point_host=$5

    expect -c "
    set timeout 10
    spawn ssh -L ${local_port}:${end_point_host}:${end_point_port} ${relay_point_user}@${relay_point_host}
    expect \"Are you sure you want to continue connecting (yes/no)?\" {
        send \"yes\n\"
    } \"${relay_point_user}@${relay_point_host}'s password:\" {
    }
    interact
    "
}

copy_passwd() {
    if which pbcopy >/dev/null 2>&1 ; then
        # Mac
        echo $1 | pbcopy
    elif which xsel >/dev/null 2>&1 ; then
        # Linux
        echo $1 | xsel --input --clipboard
    else
        # Cygwin
        echo $1 > /dev/clipboard
    fi
}
