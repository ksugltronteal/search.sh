#!/bin/bash
deletetemp=1
#from=general2.dic
#to=ivm3_5.dic
from=general12.dic
to=ivm4_12.dic

generaldic=$from
termsdic=$to
tmpdic=ivmtmp.dic
wholedic=ivmwhole.dic
##
#cat $termsdic > $tmpdic 
#echo =Delimeter= >> $tmpdic 
#cat $tmpdic $generaldic $predldic > $wholedic
##
export RML_PCRE_LIB=/proc/self/root/usr/local/lib
export RML_PCRE_INCLUDE=/proc/self/root/usr/local/include
export RML=/home/teal/morph/aot
export RMLBIN=/home/teal/morph/aot/Bin
export wd=/var/www/searchsh
hash=$(echo "$@ `date`" | md5sum | sed -e 's/ .*$//g')
filename='trequest'$hash
echo "$@ `date`" >> request.log
echo "$@" > $wd/$filename.txt
echo >> $wd/$filename.txt
iconv -f utf-8 -t cp1251 $wd/$filename.txt -o $wd/$filename-cp1251.txt
$wd/rusclear4s < $wd/$filename-cp1251.txt > $wd/$filename-cp1251.rus
#echo '29'
if [[ -e $wd/$filename-cp1251.rus ]]
then
  #echo '32'
  echo "$wd/$filename-cp1251.rus" > $wd/aots.fifo  
  #echo '34'
  i=0   
  while [ "$i" -gt "-1" ]
  do
    #echo '38'
    if [[ -e $wd/$filename-cp1251.lem ]]
    then      
      #echo '41'
	  $wd/morph_cleaner5_s $wd/$filename-cp1251.lem $wd/$filename-cp1251.end #delete RML output			
	  iconv -f cp1251 -t utf8 -o $wd/$filename.end $wd/$filename-cp1251.end
      i=-10
    else
      let i=$i+1
    fi
    if [ "$i" -gt "50" ]  
    then
      #echo '50'
      i=-10
      echo '2'
      echo "aots stream is not working properly. System is overloaded or I have a trouble."
    fi
    sleep 0.01
  done
  #echo '57'
  if [[ -e $wd/$filename.end ]]
  then 
    #echo '60'
    echo "$wd/$filename.end" > $wd/dms2s.fifo
    #echo '62'
    i=0    
    while [ "$i" -gt "-1" ]
    do
      if [[ -e $wd/$filename.end.708 ]]
        then  
          #echo '69'
          $wd/querygenerator2 < $wd/$filename.end.708 
          i=-10
        else
          let i=$i+1
        fi
      if [ "$i" -gt "20" ]  
      then
        #echo '77'
        i=-10
        echo '2'
        echo "dms2s stream is not working properly. System is overloaded or I have a trouble."
      fi
      sleep 0.01
    done   
  else  
    echo '1'
    echo "Search query can not be recognized. Use other search engine."
  fi
else
  echo '1'
  echo "Search query is empty or can not be recognized. Use other search engine."
fi

if (($deletetemp==1))
then
  rm -f $wd/$filename.txt
  rm -f $wd/$filename-cp1251.txt
  rm -f $wd/$filename-cp1251.rus
  rm -f $wd/$filename-cp1251.lem
  rm -f $wd/$filename-cp1251.end
  rm -f $wd/$filename.end
  rm -f $wd/$filename.end.708
fi
