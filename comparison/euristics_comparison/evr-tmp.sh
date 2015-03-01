#!/bin/bash
to=evristic_inf-2.dic
#dlina-4astota
sed -e '/^2 /d' index1.dic > index2.dic
sed -e 's/[^а-яА-Я]//g' index2.dic | sort > $to
