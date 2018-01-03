dir=$1

mkdir $dir/idle
mkdir $dir/safetimer

for i in 300 400 500
do
    mkdir $dir/idle/$i
    mkdir $dir/safetimer/$i
    for pkt_size in 128 256 512 1024
    do
        mkdir $dir/idle/$i/$pkt_size
        mkdir $dir/safetimer/$i/$pkt_size
    done
done

