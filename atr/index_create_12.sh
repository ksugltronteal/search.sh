#!/bin/bash
echo "clearing..."
rm -f *.end
rm -f *.end2
rm -f *.00*
rm -f *.mgs
#========================================================
#./dictionary-generator6.sh
bash ind003.sh #morph analisys
#========================================================

#termsdic=kio-terms.dic
#gendic=kio_core_1100.dic

#termsdic=terms-ru.dic
#gendic=ru-gen.dic

#termsdic=terms.dic
#gendic=kio_general.dic

#gendic=kio_core_1100.dic
#termsdic=terms_core_1100_e.dic

#from=kio_core_1100.dic
#to=terms_groups_core_1100_e.dic

#from=kio_core_1100.dic
#to=terms_kio_core_1100_e3.dic

#from=kio_core_1100.dic
#to=terms_medic_core_1100_e3.dic

#from=kio_core_1100.dic
#to=slowar.dic

#from=kio_core_1100.dic
#to=terms_medic_articles_core_1100_e.dic

#from=kio_core_1100.dic
#to=ivm.dic


#========================================================
from=general12.dic
to=ivm4_12.dic
#========================================================

#from=general2.dic	
#to=ivm3_5.dic

#from=general2.dic	
#to=mathonto2.dic

#from=general2-mathonto.dic	
#to=ivm+mathonto.dic

#from=general_20110714.dic
#to=ivm_full_20110714.dic

gendic=$from
termsdic=$to

predldic=predl.dic

#bash ind108.sh $termsdic $gendic $predldic
bash ind408.sh $termsdic $gendic $predldic
echo "generating index files..."
#./mygrep $termsdic *.008
echo "generating main index..."
#./index_generator2 $termsdic index.dat
echo "deleting temporary files..."

rm -f *.mgs
rm -f *.end2
rm -f *.end
echo "index done"
