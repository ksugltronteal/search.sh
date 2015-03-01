#!/bin/bash
./evristic-start.sh
for ((i=0; i<=6; i++)) 
do
	for ((j=0; j<=20; j++))
	do
		./evristic_generator $i $j tmp-tmp.sh
		chmod a+x tmp-tmp.sh
		./tmp-tmp.sh
	done
done
./evristic-end.sh

