#!/bin/bash


protocoles="AODV DSR"

for p in $protocoles
do


	sed  's/PROTOCOLE_VAR/'$p'/g' protocol.tcl > $p".tcl"


	rm graph.dat 2>/dev/null
	for s in {1..10}
	do
		rm moy.tr 2>/dev/null
		echo -n $s" : "
		for i in {1..30}
		do
			echo  -n $i
			[[ $i = 30 ]] && echo  "" || echo -n ","
			sed  's/SOURCES_VAR/'$s'/g' $p".tcl" > tmp.tcl
			ns tmp.tcl  &> /dev/null
			rm tmp.tcl
			awk -f script.awk results.tr  | tail -n 1 >> moy.tr
			rm results.tr 2>/dev/null
		done
		echo -n "$s " >> graph.dat
		awk -f moy.awk moy.tr  >> graph.dat
		rm moy.tr 2>/dev/null
	done

	cp graph.dat 'graph_'$p'.dat'

	rm $p".tcl" 2>/dev/null

	mkdir -p 'courbes/'$p 2>/dev/null
	gnuplot < plot.options
	echo "courbes générées" 

done






