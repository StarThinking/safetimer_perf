dir=$1

mkdir $dir/idle
mkdir $dir/safetimer

for i in 50 100 150 200
do
    mkdir $dir/idle/$i
    mkdir $dir/safetimer/$i
    for pkt_size in 64 512 4096 65536
    do
        mkdir $dir/idle/$i/$pkt_size
        mkdir $dir/safetimer/$i/$pkt_size
    done
done

