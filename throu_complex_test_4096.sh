pkt_size=4096
dir=./throu_combine_4096

ssh 10.10.1.1 "killall receiver_app"
rmmod hb_sender_tracker_opt.ko
killall sender_app

for clients in 20 40 100
do
    for repeat in 0 1 2 3 4 5 6 7 8 9
    do
        echo "idle clients $clients repeat $repeat"
        ./test.sh $clients $pkt_size ./$dir/idle/$clients/$pkt_size $repeat
        sleep 5
        
        echo "safetimer opt clients $clients repeat $repeat"
        ssh 10.10.1.1 "/root/hb-latency/heartbeat/sbin/add_filter_rule.sh"
        sleep 2
        ssh 10.10.1.1 "/root/hb-latency/heartbeat/build/receiver_app > /dev/null" &
        sleep 2
        insmod /root/hb-latency/heartbeat/kmodule/send/hb_sender_tracker_opt/hb_sender_tracker_opt.ko
        sleep 2
        /root/hb-latency/heartbeat/build/sender_app &
        ./test.sh $clients $pkt_size ./$dir/safetimer_opt/$clients/$pkt_size $repeat
        killall sender_app
        rmmod hb_sender_tracker_opt.ko
        sleep 2
        ssh 10.10.1.1 "killall receiver_app"
        ssh 10.10.1.1 "/root/hb-latency/heartbeat/sbin/del_filter_rule.sh"
        sleep 5
    done
done
