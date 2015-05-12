# EPPPPPP

intervalle de confiance :
set style fill transparent solid 0.2 noborder
plot 'graph.dat' using 1:7:8 with filledcurves title '95% confidence', \
     '' using 1:5 with lp lt 1 pt 7 ps 1.5 lw 3 title 'mean value'