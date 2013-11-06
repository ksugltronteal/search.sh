#!/bin/bash
#rusclear4 & morph_cleaner6 inside
#compatible with FileTestLem3
#compatible with ind408.sh

export RML_PCRE_LIB=/proc/self/root/usr/local/lib
export RML_PCRE_INCLUDE=/proc/self/root/usr/local/include
export RML=/home/teal/morph/aot
echo "RML variables set"
echo "Clearing workspace"
rm -f *-cp1251
rm -f *-cp1251.rus
rm -f *-cp1251.lem
rm -f *lem
rm -f *end
rm -f *end2
echo "Prepering input files"
for filename in *.txt
do
    echo "Preparing " $filename
	iconv -f utf-8 -t cp1251 $filename -o $filename-cp1251
    ./rusclear4 < $filename-cp1251 > $filename-cp1251.rus
    rm -f $filename-cp1251	#?
    #sleep 1
done
echo "Input files ready"
ls *-cp1251.rus > files.dat
echo "List of files ready"
./filetestlem_input_generator2 < files.dat > tmp.sh
#./filetestlem_input_generator2 < files.dat  > tmp.sh
#echo "./FileLem Russian files.dat">tmp.sh
echo "Morph analisys script generated"
#chmod a+x tmp.sh
bash tmp.sh
echo "Morph analisys finished"
for filename in *.txt
do	
    echo "Output clearing for "$filename.lem 
	#iconv -f cp1251 -t utf-8 $filename-cp1251.lem -o $filename.lem
	#./morph_cleaner <$filename.lem >$filename.end2	
	./morph_cleaner6 $filename-cp1251.lem $filename-cp1251.end $filename-cp1251.end2	
	iconv -f cp1251 -t utf-8 $filename-cp1251.end -o $filename.end 	
	iconv -f cp1251 -t utf-8 $filename-cp1251.end2 -o $filename.end2 	
	#sleep 1
	#sed -e 's/[^а-яА-Я ]/ /g' $filename.end2  | sed  -e 's/  / /g' | sed  -e 's/ /\n/g' | sed '/^$/d' > $filename.end	
done
rm -f *-cp1251.end*
rm -f *.rus
rm -f *.lem
#rename s/.txt.end/.end/g *.end
#rename s/.txt.end2/.end2/g *.end2
