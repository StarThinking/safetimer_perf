#!/bin/bash

get_avg () {
    file=$1
    test_count=$2
    total=0 
    
    for i in $( awk '{ print $1; }' $file)
    do
        #if (( $count == 0 ))
        #then
        #    echo "skip the first line"
        #else
            total=$(echo $total+$i | bc )
        #fi
    done
    echo "scale=2; $total / $test_count" | bc
}

get_avg $1 $2
