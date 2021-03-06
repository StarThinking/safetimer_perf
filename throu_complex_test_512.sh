pkt_size=512
dir=./throu_combine-32_512

if [ "$#" -ne 2 ]
then
    echo "wrong parameters"
    exit 1
fi

ssh 10.10.1.1 "killall receiver_app"
rmmod hb_sender_tracker.ko
killall sender_app
killall sender_app_nb

for clients in 300 400 500 600 700
do
    for repeat in 0 1 2 3 4
    do
        echo "idle clients $clients repeat $repeat"
        ./test.sh $clients $pkt_size ./$dir/idle/$clients/$pkt_size $repeat
        sleep 5
        
        echo "safetimer clients $clients repeat $repeat"
        ssh 10.10.1.1 "/root/hb-latency/heartbeat/sbin/add_filter_rule.sh"
        sleep 2
        ssh 10.10.1.1 "/root/hb-latency/heartbeat/build/receiver_app > /dev/null" &
        sleep 2
        insmod /root/hb-latency/heartbeat/kmodule/send/hb_sender_tracker/hb_sender_tracker.ko
        sleep 2
        /root/hb-latency/heartbeat/build/sender_app &
        ./test.sh $clients $pkt_size ./$dir/safetimer/$clients/$pkt_size $repeat
        killall sender_app
        rmmod hb_sender_tracker.ko
        sleep 2
        ssh 10.10.1.1 "killall receiver_app"
        ssh 10.10.1.1 "/root/hb-latency/heartbeat/sbin/del_filter_rule.sh"
        sleep 5
    done
done
