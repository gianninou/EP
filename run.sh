#!/bin/bash




rm graph.dat 2>/dev/null
for s in {1..10}
do
	rm moy.tr 2>/dev/null
	echo -n $s" : "
	for i in {1..30}
	do
		echo  -n $i
		[[ $i = 30 ]] && echo  "" || echo -n ","
		sed  's/toto/'$s'/g' AODV.tcl > tmp.tcl
		ns tmp.tcl  &> /dev/null
		rm tmp.tcl
		awk -f script.awk results.tr 2>/dev/null | tail -n 1 >> moy.tr
		rm results.tr 2>/dev/null
	done
	echo -n "$s " >> graph.dat
	awk -f moy.awk moy.tr 2>/dev/null >> graph.dat
	rm moy.tr 2>/dev/null
done


