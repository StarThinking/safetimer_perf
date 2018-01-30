#!/bin/bash

dir=$1
test_count=0

for test_dir in $dir/*
do
#    echo $test_dir
    for client_file in $test_dir/*
    do
#        echo $client_file
        head -n 1 $client_file >> $dir/throu_test_$test_count
    done
    ./get_throu_avg.sh $dir/throu_test_$test_count 1 >> $dir/to_cal_std
    ((test_count++))
done

echo "throughput mean and stardard deviation:"
    awk '{for(i=1;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2}} 
          END {for (i=1;i<=NF;i++) {
          printf "%f %f \n", (sum[i]/NR)/1000, (sqrt((sumsq[i]-sum[i]^2/NR)/NR))/1000}
         }' $dir/to_cal_std
#awk '{sum+=$1; sumsq+=$1*$1} END {print (sum/NR); print sqrt(sumsq/NR - (sum/NR)^2)}' $dir/to_cal_std

rm $dir/throu_test_*
rm $dir/to_cal_std
