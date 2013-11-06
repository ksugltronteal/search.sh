#!/bin/bash
export wd=/var/www/searchsh
cat $wd/stoplist.pid | while read pid
do
kill $pid
done
rm -f $wd/dms2s.fifo
rm -f $wd/aots.fifo
rm -f $wd/stoplist.pid
