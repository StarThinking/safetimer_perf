pkt_size=64
dir=./kprobe_xmit_none

ssh 10.10.1.1 "killall receiver_app"

for clients in 400
do
    for repeat in 0 1 2 3 4
    do
        echo "idle clients $clients repeat $repeat"
        ./test.sh $clients $pkt_size ./$dir/idle/$clients/$pkt_size $repeat
        sleep 5
        
	echo "idle kret clients $clients repeat $repeat"
	insmod /root/hb-latency/hb-receiver/others/kprobe_latency/kprobe_latency.ko
        ./test.sh $clients $pkt_size ./$dir/kret/$clients/$pkt_size $repeat
	rmmod kprobe_latency.ko
        sleep 5
    done
done
