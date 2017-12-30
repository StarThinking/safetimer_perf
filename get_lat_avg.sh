#!/bin/bash

get_avg () {
    file=$1
    count=0
    total=0 
    
    for i in $( awk '{ print $1; }' $file)
    do
        #if (( $count == 0 ))
        #then
        #    echo "skip the first line"
        #else
            total=$(echo $total+$i | bc )
        #fi
        ((count++))
    done
    echo "scale=2; $total / $count" | bc
}

get_avg $1
