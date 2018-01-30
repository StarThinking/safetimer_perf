#!/bin/bash

dir=$1
clients=$2
test_count=0

99_lat () {
    sorted_file=$1
    lines=`wc -l < $sorted_file`
    #echo sorted file $sorted_file has $lines lines

    line50=`echo "scale=0; ($lines * 0.50)/1" | bc -l`
    line95=`echo "scale=0; ($lines * 0.95)/1" | bc -l`
    line99=`echo "scale=0; ($lines * 0.99)/1" | bc -l`
    line999=`echo "scale=0; ($lines * 0.999)/1" | bc -l`

    #9995line=$(( $lines * 0.9995 ))
    #9999line=$(( $lines * 0.999 ))
    sed -n "$line50"p $sorted_file >> $2

    sed -n "$line95"p $sorted_file >> $3

    sed -n "$line99"p $sorted_file >> $4

    sed -n "$line999"p $sorted_file >> $5
}

for test_dir in $dir/*
do
#    echo $test_dir
    for client_file in $test_dir/*
    do
#        echo $client_file
         tail -n +3 $client_file >> $dir/lat_test_$test_count
    done
    sort -n $dir/lat_test_$test_count >> $dir/lat_test_sorted_$test_count
    99_lat $dir/lat_test_sorted_$test_count $dir/to_cal_std50 $dir/to_cal_std95 $dir/to_cal_std99 $dir/to_cal_std999
    ((test_count++))
done

for i in 50 95 99 999
do
    echo "mean and stardard deviation of $i"p" latency:"
    awk '{for(i=1;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2}} 
          END {for (i=1;i<=NF;i++) {
          printf "%f %f \n", (sum[i]/NR)/1000, (sqrt((sumsq[i]-sum[i]^2/NR)/NR))/1000}
         }' $dir/to_cal_std$i
    echo ""
done
#awk '{sum+=$1; sumsq+=$1*$1} END {print (sum/NR); print sqrt(sumsq/NR - (sum/NR)^2)}' $dir/to_cal_std

rm $dir/lat_test_*
rm $dir/to_cal_std*
