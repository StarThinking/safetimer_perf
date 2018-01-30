dir=$1
clients=$2

./get_standard_dev_99lat.sh $dir $clients
./get_standard_dev_avglat.sh $dir $clients
./get_standard_dev_throu.sh $dir
