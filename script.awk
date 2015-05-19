BEGIN {

	record_time = 0.0;
	time_interval = 1.0;
	
	send_count=0;
	received_count=0;
	received_count_size=0;
	total_count=0;
	dropped_count=0;
	ber=0.0;
	bandwith=0.0;

	
	total_time_moy=0.0;
	agt_received=0;
}

{
	action = $1;
	time = $2;
	src = $3;
	dst = $4;
	name = $5;
	size = $6
	paquet_type = $7;
	flow_id = $8;
	src_address = $9;
	dst_address = $10;
	seq_no = $11;
	packet_id = $18; 

	
	if (action == "s" && paquet_type == "cbr") {    
		send_count = send_count + 1; 
		if(dst == "AGT"){
			#printf "----\n";
			tab[packet_id]=time;

			#printf "packet_id s : %s\n", packet_id;
			#printf "tab[packet_id] : %f\n", tab[packet_id];
		}
	}

	if (action == "r" && paquet_type == "cbr") {    
		received_count = received_count + 1; 
		received_count_size = received_count_size + size;
		if(dst == "AGT"){
			#printf "----\n";
			#printf "packet_id r : %s\n", packet_id;
			#printf "time %f tab %f  --> diff : %f\n",time,tab[packet_id], (time - tab[packet_id]);
			total_time_moy = total_time_moy + (time - tab[packet_id]);
			agt_received=agt_received+1;
		}

	}
	if (action == "D" && paquet_type == "cbr") {    
		dropped_count = dropped_count + 1; 
	}
	
}

END {
	
	if(agt_received>0){
		total_time_moy = total_time_moy / agt_received 
	}else{
		total_time_moy=0;
	}
	ber = ((dropped_count)/send_count)*100;
	printf "time : %f\n",time;
	bandwith = received_count_size/time;	

	#printf "send : %d\n",send_count;
	#printf "received : %d\n",received_count;
	#printf "dropped : %d\n",dropped_count;
	#printf "ber : %f%\n",ber;
	#printf "bandwith %f\n",bandwith;

	printf "%d %d %d %f %f %f\n",send_count,received_count,dropped_count,ber,bandwith,total_time_moy
}