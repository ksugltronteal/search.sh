#!/bin/bash
#+term 
#preview_generator2 inside
lcname=$(echo $1 | sed -e 's/\..*$//g')
ivmid=$(grep ";$lcname" mapping.csv | sed -e 's/;.*$//g')
li=$(echo $ivmid | wc -c)
if (($li>1))
then
score=$(grep "$ivmid;" ranks3.csv | sed -e 's/;.*$//g')
hits=$(grep "$ivmid;" hitsranks.csv | sed -e 's/;/\n/g')
mn4=$(grep "$ivmid;" mn4solr.csv)
title=$(echo $mn4 | sed -e 's/;;.*$//g' -e 's/^.*;//g')
udk=$(echo $mn4 | sed -e 's/;;;.*$//g' -e 's/^.*;;//g')
author=$(echo $mn4 | sed -e 's/;;;;.*$//g' -e 's/^.*;;;//g')
year=$(echo $mn4| sed -e 's/^.*;;;;//g')
hh=$(echo $hits | wc -m)
echo '     <field name="score1">'$score'</field>' >score.tmp
echo '     <field name="title">'$title'</field>' >>score.tmp
echo '     <field name="udk">'$udk'</field>' >>score.tmp
echo '     <field name="author">'$author'</field>' >>score.tmp
echo '     <field name="year">'$year'</field>' >>score.tmp
#echo '     <field name="link">http://www.mathnet.ru/'$ivmid'</field>'>>score.tmp
echo '     <field name="link">away.php?l='$ivmid'</field>'>>score.tmp
if (($hh<3))
  then
    echo '     <field name="authority">0</field>'>>score.tmp
    echo '     <field name="hub">0</field>'>>score.tmp
    echo '     <field name="pagerank">0</field>'>>score.tmp
  else
    bash parse_hits.sh $hits >>score.tmp
fi
sed -e's/\&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' $lcname.txt  > $lcname.tmp
./preview_generator2 $1 $lcname.tmp $(cat $lcname.tmp | wc -l) > $1.xml
rm $lcname.tmp
else
#rm $1.xml
echo '==========================>>>BAD IVMID<<<=========================='
echo $1
fi
