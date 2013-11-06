#!/bin/bash
#compatible with rusclear4 and morph_cleaner6 (ind003)
#dictionary_manipulator_408 inside

#file index uid
i=8
#creating dictionaries
#cat $1 > tmp_d.dic 
#echo "=Delimeter=" >> tmp_d.dic
#echo "=CommaDelimeter=" >> tmp_d.dic
#cat kio-terms.dic predl.dic > kio-terms_p.dic
#echo $1 $2 $3
cat $1 $2 $3 > tmp.dic
./dictionary_manipulator_408 tmp.dic $2 $1 *.end
for filename in *.end
do
    echo 'ind408.sh for' $filename
	sed -e 's/=DELIMETER= /\n/g' -e 's/  / /g' $filename.70$i | sed -e '/^$/d' > $filename.20$i	
	echo 'index_again in ind408 for '	$filename
	./index_again $filename'2' $filename.20$i $filename.30$i
	#sleep 1
done
#rm -f *.00$i
rm -f *.20$i
rm -f *.70$i
rm tmp.dic
#rm tmp_d.dic
rename "s/.end.30$i/.00$i/g" *.30$i
