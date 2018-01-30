dir=$1

mkdir $dir/idle
#mkdir $dir/safetimer
mkdir $dir/safetimer_opt
#mkdir $dir/kret

for i in 3 8 20
do
    mkdir $dir/idle/$i
#    mkdir $dir/safetimer/$i
    mkdir $dir/safetimer_opt/$i
#    mkdir $dir/kret/$i
    for pkt_size in 8 64 4096 65536
    do
        mkdir $dir/idle/$i/$pkt_size
#        mkdir $dir/safetimer/$i/$pkt_size
        mkdir $dir/safetimer_opt/$i/$pkt_size
#        mkdir $dir/kret/$i/$pkt_size
    done
done

