#!/bin/bash

# authors: liminggui
# 示例
# 执行test.sh最长3秒, 可获取错误码
# 注意:参数内不能含有空格
# ./timeout.sh 3 ./test.sh

# 超时时间
waitfor=${1:-3}
shift

# 杀进程
killpids()
{
    pid=$1
    if [ "$pid" = "" ];then
        return
    fi

    # 找到子进程
    treepids=$(pstree -a -A -p $pid|sed 's#|##g'|awk '{print $1}'|awk -F ',' '{print $NF}')

    # 再做一次安全过滤,防止pids取错,并拼成一行
    kpids=''
    for line in $treepids
    do
        if [ "$line" -ge "$pid" ];then
            kpids="${kpids} ${line}"
        fi
    done
    kill -9 $kpids
}

# 超时监控
timeout()
{
    command=$*
    if [ "$command" = "" ];then
        return
    fi
    $command &
    commandpid=$!

    # watch dog, sleep output to null for php exec
    ( sleep $waitfor > /dev/null;killpids $commandpid > /dev/null 2>&1 ) &
    sleeppid=$!

    wait $commandpid
    ret=$?

    # 程序正常时,杀死监控
    killpids $sleeppid > /dev/null 2>&1
    return $ret
}

timeout "$*"
