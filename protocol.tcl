# Définition des variables pour la simulation de notre réseau sans-fil

set val(chan) Channel/WirelessChannel; # Type de canal
set val(prop) Propagation/TwoRayGround; # Propagation radio
set val(netif) Phy/WirelessPhy; # Type de l'interface réseau
set val(mac) Mac/802_11; # Support du wireless
set val(ifq) Queue/DropTail/PriQueue; # Priorité de la file
set val(ll) LL; # Type de la couche de liaison
set val(ant) Antenna/OmniAntenna; # Type de l'antenne
set val(ifqlen) 150; # Taille de la queue
set val(x) 1000; # X Largeur de la région (en mètres)
set val(y) 1000; # Y Hauteur de la région (en mètres)
set val(nn) 20; # Nombre de nœuds
set val(stop) 60; # Temps de la simulation (en secondes)
set val(sources) SOURCES_VAR;  
# Nombre de sources passé en argument 
set val(packet_size) 512; # Taille des paquets envoyés (en octets)
set val(interval) 0.1; # Intervalle d'envoi de paquets (en secondes)
set val(rp) PROTOCOLE_VAR; # Protocole de routage

# Définition de la variable de Random pour le placement des nœuds dans la région
global defaultRNG
$defaultRNG seed 0
set sizeRNG [new RNG]
$sizeRNG next-substream
set size_ [new RandomVariable/Uniform]; # Variable Random uniforme
$size_ set min_ 1; # Valeur minimum
$size_ set max_ 999; 
# Valeur maximum
$size_ use-rng $sizeRNG 
# Création du simulateur NS

set ns [new Simulator]
# Paramétrage de l'antenne
# Direction de X
Antenna/OmniAntenna set X_ 0;
Antenna/OmniAntenna set Y_ 0; #&nbsp;&nbsp; &nbsp;&nbsp;

Antenna/OmniAntenna set Z_ 1.5; # Direction de Y
Antenna/OmniAntenna set Gt_ 1.0; # Gain de transmission
Antenna/OmniAntenna set Gr_ 1.0; # Gain de reception

# Paramétrage de l'interface réseau
Phy/WirelessPhy set CPThresh_ 10.0; # Collision Threshold
Phy/WirelessPhy set CSThresh_ 1.559e-11;# Portée de détection : 500 mètres
Phy/WirelessPhy set RXThresh_ 6.97078e-10; # Portée de communication : 200 mètres (-91,1db)
Phy/WirelessPhy set bandwidth_ 2e6; # Capacité du médium : 2Mbits
Phy/WirelessPhy set Pt_ 0.28183815; # Puissance de transmission : 24.5dbm
Phy/WirelessPhy set freq_ 914e+6; # Fréquence : 914MHz
Phy/WirelessPhy set L_ 1.0; # System Loss Factor
# Création des fichiers de trace

set f [open results.tr w]
$ns trace-all $f
$ns eventtrace-all
set nf [open aodv_sim.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)

# Topographie de la simulation
set topo [new Topography];
# Création de la région pour la simulation
$topo load_flatgrid $val(x) $val(y)

# Création du God
create-god $val(nn)

# Création du canal
set chan [new $val(chan)]

# Configuration du nœud
$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channel $chan \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace ON \
-movementTrace OFF

# Création des nœuds pour la simulation
for {set i 0} {$i < $val(nn)} {incr i} {
set node_($i) [$ns node]
$node_($i) random-motion 0
}
# Position des nœuds dans la région de manière aléatoire
for {set i 0} {$i < $val(nn)} {incr i} {
$node_($i) set X_ [expr round([$size_ value])]]
$node_($i) set Y_ [expr round([$size_ value])]]
$node_($i) set Z_ 0.0
}

# Création des agents pour les nœuds sources
for {set i 0} {$i < $val(sources)} {incr i} {
set udp_($i) [new Agent/UDP]
$ns attach-agent $node_($i) $udp_($i)

# Creation de agent Null
set null_($i) [new Agent/Null]
$ns attach-agent $node_([expr [expr $val(nn) - 1] - $i]) $null_($i)
$ns connect $udp_($i) $null_($i)

# Création et paramètrage du CBR
set cbr_($i) [new Application/Traffic/CBR];
$cbr_($i) attach-agent $udp_($i)
$cbr_($i) set type_ CBR;  # Type du CBR
$cbr_($i) set packet_size_ $val(packet_size);  # Taille des paquets envoyés
$cbr_($i) set rate_ [expr $val(packet_size) * 8 / [$ns delay_parse $val(interval)]]; # Taux
$cbr_($i) set random_ false

# Début d'envoi de paquets pas en même temps, sinon Erreur de segmentation
$ns at [expr 0.1 * $i] "$cbr_($i) start"; # Début d'envoi de paquets
$ns at $val(stop) "$cbr_($i) stop"; # Fin d'envoi de paquets
}


# Positionne les nœuds sur la grille
for {set i 0} {$i < $val(nn)} {incr i} {
$ns initial_node_pos $node_($i) 30; # 30 : taille du nœud dans nam
}
# Arrêt de la simulation
$ns at $val(stop) "finish"
$ns at [expr $val(stop) + 0.1] "$ns halt"
# Fonction appelée pour terminer la simulation
proc finish {} {
global ns f nf val
$ns flush-trace
close $f
close $nf
# exec nam aodv_sim.nam &       
exit 0
}
# Début de la simulation
$ns run

