#!/bin/bash
#compatible with ind002d.sh

export RML_PCRE_LIB=/proc/self/root/usr/local/lib
export RML_PCRE_INCLUDE=/proc/self/root/usr/local/include
export RML=/home/teal/morph/aot
echo "RML variables set"

#
#from=kio_general.dic
#to=terms.dic

#from=ru-gen.dic
#to=terms-ru.dic

#from=kio_core_1100.dic
#to=terms_kio_core_1100_e.dic

#from=kio_core_1100.dic
#to=terms_kio_core_1100.dic

#from=kio_core_1100.dic
#to=ivm.dic

###from=general2.dic	
#to=ivm3.dic
###to=ivm3_5.dic
##to=kiokio.dic

from=general12.dic
to=ivm4_12.dic
#to=evristic_dg6.dic

#from=kio_core_1100.dic
#to=terms_groups_core_1100_e2.dic

#from=kio_core_1100.dic
#to=terms_groups_core_1100.dic

#from=kio_core_1100.dic
#to=terms_groups_core_1100_e.dic

#from=kio_core_1100.dic
#to=terms_medic_core_1100_e.dic
#to=terms_medic_core_1100.dic

#from=kio_core_1100.dic
#to=slowar.dic

#from=kio_core_1100.dic
#to=terms_medic_articles_core_1100_e.dic
#
bash ind002d.sh

rm -f *.olm
cat $from predl.dic | sort | uniq | sed '/^$/d' > tmp.dic

echo "Adding files to dictionary"

./dictionary_complementation10 tmp.dic *.end

echo "Optimization of dictionary.."
rm -f tmp.dic

cat *.olm > olmu.dat
sort olmu.dat | uniq -c | sort -gr | sed -e 's/^ *//' > index1.dic

sed -e '/^1 \|^\([2-9]\|1[0-9]\) ..$\|^[2-5] ...$\| .$/d' index1.dic > index2.dic

sed -e 's/^[0-9]* //g' index2.dic | sort > $to

echo "Dictionary $to is ready"

#rm index*.dic
rm *.olm
rm *.rus
rm *.lem
#rm *.end
#rm *.end2
