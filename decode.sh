cat datos.csv | tr "+" "," | awk -F, '$1!=""' > cleandatos.csv # limpieza de datos
N=$(wc -l cleandatos.csv | awk '{print $1}') # conteo de renglones

echo "pm25,pm10,CO2,VOC,TMP,HM,cks,lugar,fecha" > decodeData.csv

for i in $(seq 0 $N)
do
        data=$(cat cleandatos.csv | awk -F, -v var=$i 'FNR == var {print $1}')
        remain=$(cat cleandatos.csv | awk -F, -v var=$i 'FNR == var {print $2,$3}' | tr " " "," )
        val=$(echo ${data:0:2})

        pm25=$(echo "obase=10; ibase=16; "$(echo ${data:10:4} | tr [a-z] [A-Z])"" | bc)
        pm10=$(echo "obase=10; ibase=16; "$(echo ${data:14:4} | tr [a-z] [A-Z])"" | bc)
        co2=$(echo "obase=10; ibase=16; "$(echo ${data:18:4} | tr [a-z] [A-Z])"" | bc)
        voc=$(echo "obase=10; ibase=16; "$(echo ${data:22:4} | tr [a-z] [A-Z])"" | bc)
        temp=$(echo "obase=10; ibase=16; "$(echo ${data:26:4} | tr [a-z] [A-Z])"" | bc)
        hum=$(echo "obase=10; ibase=16; "$(echo ${data:30:4} | tr [a-z] [A-Z])"" | bc)
        cks=$(echo "obase=10; ibase=16; "$(echo ${data:34:4} | tr [a-z] [A-Z])"" | bc)

        if [ $val == "01" ]
        then
                echo $pm25,$pm10,$co2,$voc,$temp,$hum,$cks,$remain >> decodeData.csv
        fi
done
