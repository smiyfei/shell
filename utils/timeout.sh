#!/bin/bash

# 示例
# 执行test.sh最长3秒, 可获取错误码
# ./timeout.sh 3 ./test.sh

# 超时时间
waitfor=$1
shift

timeout()
{
        command=$*
        $command &
        commandpid=$!

        ( sleep $waitfor ; kill -9 $commandpid  > /dev/null 2>&1) &

        watchdog=$!
        sleeppid=$PPID
        wait $commandpid > /dev/null 2>&1
        # 是否超时
        ret=$?

        kill $sleeppid > /dev/null 2>&1

        if [ "$ret" != "0" ]; then
            echo "execute command timeout" >&2
        fi
        return $ret
}

timeout "$*"
