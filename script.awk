BEGIN {

	record_time = 0.0;
	time_interval = 1.0;
	
	send_count=0;
	received_count=0;
	total_count=0;
	dropped_count=0;
	ber=0.0;
	bandwith=0.0;
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
	packet_id = $12; 

	if (action == "s" && paquet_type == "cbr") {    
		send_count = send_count + 1; 
	}
	if (action == "r" && paquet_type == "cbr") {    
		received_count = received_count + 1; 
	}
	if (action == "D" && paquet_type == "cbr") {    
		dropped_count = dropped_count + 1; 
	}
	
}

END {
	
	ber = ((dropped_count)/send_count)*100;
	bandwith = received_count*size/time;	

	#printf "send : %d\n",send_count;
	#printf "received : %d\n",received_count;
	#printf "dropped : %d\n",dropped_count;
	#printf "ber : %f%\n",ber;
	#printf "bandwith %f\n",bandwith;

	printf "%d %d %d %f %f\n",send_count,received_count,dropped_count,ber,bandwith
}