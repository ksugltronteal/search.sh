#!/bin/bash
to=evristic_final.dic
#dlina-4astota
sed -e '/ .$/d' -e '/^1 /d' -e '/^2 ..$/d' -e '/^2 ...$/d' -e '/^3 ..$/d' index1.dic > index2.dic
sed -e 's/[^а-яА-Я]//g' index2.dic | sort > $to
