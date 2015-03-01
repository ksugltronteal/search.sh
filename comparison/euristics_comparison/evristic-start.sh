#!/bin/bash
export RML_PCRE_LIB=/proc/self/root/usr/local/lib
export RML_PCRE_INCLUDE=/proc/self/root/usr/local/include
export RML=/home/teal/morph/aot
echo "RML variables set"
#####################################

from=kio_core_1100.dic	
#to=evristic_1-inf.dic
#dlina-4astota
#####################################3


rm -f *.olm
cat $from predl.dic | sort | uniq | sed '/^$/d' > tmp.dic
for filename in *.txt
do
	echo "Preparing " $filename
    ./rusclear < $filename > $filename.rus
	iconv -f utf-8 -t cp1251 $filename.rus -o $filename-cp1251.rus	
done
echo "Input files ready"
ls *-cp1251.rus > files.dat
./filetestlem_input_generator < files.dat > tmp.sh
chmod a+x tmp.sh
./tmp.sh
echo "Morph analisys finished"
for filename in *.txt
do	
    echo "Output clearing for " $filename.lem 
	iconv -f cp1251 -t utf-8 $filename-cp1251.lem -o $filename.lem
	./morph_cleaner <$filename.lem >$filename.end2
	#sed -e 's/[^а-яА-Я0-9-]//g' $filename.end3 > $filename.end2
	sed -e 's/[^а-яА-Я ]/ /g' $filename.end2  | sed  -e 's/  / /g' | sed  -e 's/ /\n/g' | sed '/^$/d' > $filename.end	
	sort $filename.end > $filename-o.lem
    ./dictionary_complementation tmp.dic $filename-o.lem $filename.olm 
    rename s/.txt.olm/.olm/g $filename.olm 
done
rm -f tmp.dic
cat *.olm | sed -e '/=Delimeter=/d' > olmu.dat
sort olmu.dat | uniq -c | sort -gr | sed -e 's/^ *//' > index1.dic
