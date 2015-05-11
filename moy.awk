BEGIN{

s_t=0;
r_t=0;
d_t=0;
be_t=0.0;
ba_t=0.0;
count=0;
}

{
s=$1;
r=$2;
d=$3;
be=$4;
ba=$5;

s_t = s_t + s;
r_t=r_t + r;
d_t=d_t + d;
be_t=be_t + be;
ba_t=ba_t + ba;
count=count+1;



}

END{


printf "%d mesures\n",count;
printf "send %d\n",s_t/count;
printf "received %d\n",r_t/count;
printf "dropped %d\n",d_t/count;
printf "ber %f\n",be_t/count;
printf "bandwith %f\n",ba_t/count;

printf "%d %d %d %f %f\n",s_t/count,r_t/count,d_t/count,be_t/count,ba_t/count;

}
