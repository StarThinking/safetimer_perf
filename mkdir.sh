dir=$1

mkdir $dir/idle
mkdir $dir/safetimer_nb
mkdir $dir/safetimer

for i in 16 32 64 128 220 240 256 300 512 600
do
    mkdir $dir/idle/$i
    mkdir $dir/idle/$i/64

    mkdir $dir/safetimer_nb/$i
    mkdir $dir/safetimer_nb/$i/64
    
    mkdir $dir/safetimer/$i
    mkdir $dir/safetimer/$i/64

done

