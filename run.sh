#!/bin/bash




rm final.tr 2>/dev/null
for s in {1..10}
do
	rm moy.tr 2>/dev/null
	for i in {1..30}
	do
		echo  -n $i
		[[ $i = 30 ]] && echo  "" || echo -n ","
		sed  's/toto/'$s'/g' Exemple_AODV_static.tcl > tmp.tcl
		ns tmp.tcl  &> /dev/null
		rm tmp.tcl
		awk -f script.awk results.tr 2>/dev/null | tail -n 1 >> moy.tr
	done
	awk -f moy.awk moy.tr >> final.tr
done

