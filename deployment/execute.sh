for x in $( cat hosts.txt ); 
do 
	#ssh $x ; 
	for y in $( cat commands.txt ); 
	do 
		#ssh $x ; 
		echo $y $x;
	done
done