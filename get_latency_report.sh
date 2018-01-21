#!/bin/bash

dir=$1
test_count=0

for test_dir in $dir/*
do
#    echo $test_dir
    for client_file in $test_dir/*
    do
#        echo $client_file
        tail -n +3 $client_file >> $dir/client_lat.sum
        head -n 2 $client_file | tail -n +2 >> $dir/avg_latency.sum
        head -n 1 $client_file >> $dir/avg_throughput.sum
    done
    ((test_count++))
done

sort -n $dir/client_lat.sum >> $dir/client_lat_sorted.sum

rm $dir/client_lat.sum

99_lat () {
    sorted_file=$1
    lines=`wc -l < $sorted_file`
    echo sorted file $sorted_file has $lines lines

    line50=`echo "scale=0; ($lines * 0.50)/1" | bc -l`
    line95=`echo "scale=0; ($lines * 0.95)/1" | bc -l`
    line99=`echo "scale=0; ($lines * 0.99)/1" | bc -l`
    line999=`echo "scale=0; ($lines * 0.999)/1" | bc -l`

    #9995line=$(( $lines * 0.9995 ))
    #9999line=$(( $lines * 0.999 ))
    printf "%s: " "50%"
    sed -n "$line50"p $sorted_file
    
    printf "%s: " "95%"
    sed -n "$line95"p $sorted_file
    
    printf "%s: " "99%"
    sed -n "$line99"p $sorted_file
    
    printf "%s: " "99.9%"
    sed -n "$line999"p $sorted_file
}

99_lat $dir/client_lat_sorted.sum

printf "%s: " "avg of avg latency"
./get_lat_avg.sh $dir/avg_latency.sum
printf "%s: " "avg of avg throughput"
./get_throu_avg.sh $dir/avg_throughput.sum $test_count

rm $dir/client_lat_sorted.sum
rm $dir/avg_latency.sum
rm $dir/avg_throughput.sum
