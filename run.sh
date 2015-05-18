#!/bin/bash


protocoles="DSR AODV"

for p in $protocoles
do

	echo $p

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
			
			ok=1
			while [ $ok -ne 0 ]
			do
				ns tmp.tcl  &> /dev/null
				ok=$?
			done

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

	mkdir -p 'courbes/' 2>/dev/null
	gnuplot < 'plot_'$p'.options'
	echo "courbes générées" 

done






