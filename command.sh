#! /bin/bash

port1=777
port2=888

flag=0
n=1
a=$(lsof -i tcp:$port1 | grep LISTEN | awk '{print $2}')
b=$(lsof -i tcp:$port2 | grep LISTEN | awk '{print $2}')

s1='S109E9'
s2='S103E9'
s3="P1E9"

while [ ! -s msg1 ] || [ ! -s msg2 ]
do
        rm msg1
        rm msg2
        if [[ $flag -eq 0 ]]; then
                echo "01 04 00 0A 00 07 91 CA" | xxd -r -p | nc -l -v $port1 > msg1 &
                echo "01 04 00 0A 00 07 91 CA" | xxd -r -p | nc -l -v $port2 > msg2 &
        elif [[ $flag -eq 1 ]]; then
                echo "01 04 00 0A 00 07 91 CA" | xxd -r -p | nc -l -v $port1 > msg1 &
        elif [[ $flag -eq 2 ]]; then
                echo "01 04 00 0A 00 07 91 CA" | xxd -r -p | nc -l -v $port2 > msg2 &
        fi

        sleep 3s

        fuser -k 777/tcp 
        fuser -k 888/tcp 

        if [ -s msg2 ]; then
                cp msg2 msg2.tmp
                flag=1
        elif [ -s msg1 ]; then
                cp msg1 msg1.tmp
                flag=2
        fi

        n=$(($n+1))
        echo "$n"
        if [[ $n -eq 10 ]]; then
                flag=1
                break;
        fi
        [ -s msg1 ] && [ -s msg2 ] && break;
done

xxd msg1
xxd msg2

if [[ $flag -eq 0 ]]; then
        xxd msg1.tmp | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}' | tr -d \. | awk '{printf $0}' | tr -d '[:space:]' | awk '{print substr($1,1,38)}' >> datos.csv
        xxd msg2.tmp | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}' | tr -d \. | awk '{printf $0}' | tr -d '[:space:]' | awk '{print substr($1,1,38)}' >> datos.csv
elif [[ $flag -eq 1 ]]; then
        echo '00000000000000000000000000000000000000' >> datos.csv
        xxd msg2.tmp | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}' | tr -d \. | awk '{printf $0}' | tr -d '[:space:]' | awk '{print (substr($1,1,38) "P1E9")}' >> datos.csv
elif [[ $flag -eq 2 ]]; then
        xxd msg1.tmp | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}' | tr -d \. | awk '{printf $0}' | tr -d '[:space:]' | awk '{print substr($1,1,38)}' >> datos.csv
        echo '00000000000000000000000000000000000000' >> datos.csv
else

        a='00000000000000000000000000000000000000' 
        echo $a+$s1 >> datos.csv
        echo '00000000000000000000000000000000000000' >> datos.csv
        echo '00000000000000000000000000000000000000' >> datos.csv
fi

rm msg1
rm msg2
