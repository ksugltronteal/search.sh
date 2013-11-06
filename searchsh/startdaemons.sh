#!/bin/bash
export RML=/home/teal/morph/aot
export RMLBIN=/home/teal/morph/aot/Bin
export wd=/var/www/searchsh

export from=general12.dic
export to=ivm4_12.dic

export generaldic=$from
export termsdic=$to
export tmpdic=ivmtmp.dic
export wholedic=ivmwhole.dic
##
#cat $termsdic > $tmpdic 
#echo =Delimeter= >> $tmpdic 
#cat $tmpdic $generaldic $predldic > $wholedic
##
rm -f $wd/stoplist.pid
rm -f $wd/dms2s.fifo
mkfifo $wd/dms2s.fifo
bash $wd/mycat.sh > $wd/dms2s.fifo &
echo $! > $wd/stoplist.pid
#echo $! > /tmp/srv-input-cat-pid
cat $wd/dms2s.fifo | $wd/dictionary_manipulator_s3 $wd/$wholedic $wd/$generaldic $wd/$termsdic &
echo $! >> $wd/stoplist.pid

rm -f $wd/aots.fifo
mkfifo $wd/aots.fifo
bash $wd/mycat.sh > $wd/aots.fifo &
echo $! >> $wd/stoplist.pid
#echo $! > /tmp/srv-input-cat-pid
cat $wd/aots.fifo | $wd/TestLem2s Russian > /dev/null &
echo $! >> $wd/stoplist.pid


echo '1'
echo 'Query daemons started'
#sleep 1
#bash morph_s.sh $1
