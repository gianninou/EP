BEGIN{

s_t=0;
r_t=0;
d_t=0;
be_t=0.0;
be_square = 0.0;
be_stand_dev = 0.0;
be_min95 = 0.0;
be_max95 = 0.0;
ba_t=0.0;
ba_stand_dev = 0.0;
ba_min95 = 0.0;
ba_max95 = 0.0;
count=0;
}

{
s=$1;
r=$2;
d=$3;
be=$4;
ba=$5;

s_t += + s;
r_t += r;
d_t += d;
be_t += be;
be_square += be * be;
ba_t += ba;
ba_square += ba * ba;
count=count+1;



}

END{

be_stand_dev = sqrt(be_square/count - (be_t/count)**2);

be_min95 = be_t/count - 1.96*be_stand_dev/sqrt(count);
be_max95 = be_t/count + 1.96*be_stand_dev/sqrt(count);

ba_stand_dev = sqrt(ba_square/count - (ba_t/count)**2);

ba_min95 = ba_t/count - 1.96*ba_stand_dev/sqrt(count);
ba_max95 = ba_t/count + 1.96*ba_stand_dev/sqrt(count);

#printf "%d mesures\n",count;
#printf "send %d\n",s_t/count;
#printf "received %d\n",r_t/count;
#printf "dropped %d\n",d_t/count;
#printf "ber %f\n",be_t/count;
#printf "bandwith %f\n",ba_t/count;

# moy paquet envoyés | moy paquets reçus | moy paquet perdu | moy BER | moy bandwidth | BE 95%- | BER 95%+ | Bandwidth 95%- | Band 95%+
printf "%d %d %d %f %f %f %f %f %f\n",s_t/count,r_t/count,d_t/count,be_t/count,ba_t/count,be_min95,be_max95,ba_min95,ba_max95;

}
