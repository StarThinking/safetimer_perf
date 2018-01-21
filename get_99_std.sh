#for os in 14 16 
#do 
#    echo $os
#    for client in 32 64 128 256
#    do
#        echo client $client idle
#        ./get_standard_dev_99lat.sh ../u"$os"_1s/combine-32/idle/$client/64
#        echo client $client safetimer
#        ./get_standard_dev_99lat.sh ../u"$os"_1s/combine-32/safetimer/$client/64
#    done
#done

for client in 32 64 128 256
do
    echo client $client idle
    ./get_standard_dev_99lat.sh ../u16_1s/combine-32_ns/idle/$client/64
    echo client $client safetimer
    ./get_standard_dev_99lat.sh ../u16_1s/combine-32_ns/safetimer/$client/64
done



