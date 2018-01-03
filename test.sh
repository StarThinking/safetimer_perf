#!/bin/bash
# Test{client_num, packet_size}  

client_num=$1
packet_size=$2
result_dir=$3
benchmark_dir=/root/safetimer_perf/pingpong

suffix="_$4"
repeat=1 #starts from 0
server_ip="10.10.1.1"
time=60000000 #us

for test_num in $(seq 0 $repeat)
do
        echo "test case: client_num = $client_num packet_size = $packet_size starts $test_num"

        ssh $server_ip "cd $benchmark_dir; killall server;"
        killall client

        sleep 5

        ssh $server_ip "cd $benchmark_dir; ./server $packet_size;" &
        echo "server started"

        sleep 5

        mkdir $result_dir/$test_num$suffix
        for((i=0; i<$client_num; i++))
        do
            $benchmark_dir/client $server_ip $packet_size $time > $result_dir/$test_num$suffix/$i.txt &
            pids[$i]=$!
        done

        for((i=0; i<$client_num; i++))
        do
            wait ${pids[$i]}
        done

	echo "test case: client_num = $client_num packet_size = $packet_size ends $test_num"

        sleep 10
done
