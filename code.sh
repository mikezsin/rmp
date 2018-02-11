#/bin/bash
bzdisch () {
echo $1 >> result.txt;
}

>result.txt
bzdisch "#Поиск 5ти пользователей, сгенерировавших наибольшее количество запросов"
bzdisch "#user,count"
awk  -F, 'NR>1{arr[$2]++} END {for (i in arr) {print i==""?"anonymous":i,arr[i]}}' shkib.csv | sort -n -k2 | tail -n5  | awk '{$1=$1}1' OFS=",">>result.txt

bzdisch "#Поиск 5ти пользователей, отправивших наибольшее количество данных"
bzdisch "#user,byte"
awk -F, 'NR>1{arr[$2]+=$8} END {for (i in arr) {print i==""?"anonymous":i,arr[i]}}' shkib.csv | sort -n -k2 |tail -n5 | awk '{$1=$1}1' OFS=",">>result.txt

bzdisch "#Поиск регулярных запросов (запросов выполняющихся периодически) по полю src_user"
bzdisch "#Т. е. запросы >1, у который одинаковые src_user, src_ip, dest_ip, dest_port. dest_user неизвестно как резолвится, поэтому его в расчет не берем"
read -p "Enter src_user: " src_user
awk -v src_ip="$src_user" -F , ' $2 == src_user {print;}' shkib.csv | awk -F, 'NR>1{ i = $2","$3","$6","$7; if (arr[i]=="") { arr[i]=$0; arrb[i]=$0; } else { if(arrb[i]!="") { print arrb[i]; arrb[i]=""; } print $0; } } END { }'>>result.txt

bzdisch "#Поиск регулярных запросов (запросов выполняющихся периодически) по полю src_ip"
bzdisch "#Т. е. запросы >1, у который одинаковые src_user, src_ip, dest_ip, dest_port. dest_user неизвестно как резолвится, поэтому его в расчет не берем"
read -p "Enter src_ip: " src_ip
awk -v src_ip="$src_ip" -F , ' $3 == src_ip {print;}' shkib.csv | awk -F, 'NR>1{ i = $2","$3","$6","$7; if (arr[i]=="") { arr[i]=$0; arrb[i]=$0; } else { if(arrb[i]!="") { print arrb[i]; arrb[i]=""; } print $0; } } END { }'>>result.txt

bzdisch "#5 не сделал"

in="result.txt"
CHARSET="$(file -bi "$in"|awk -F "=" '{print $2}')"
if [ "$CHARSET" != utf-8 ]; then
        iconv -f "$CHARSET" -t utf8 "$in" -o "$in"

fi
