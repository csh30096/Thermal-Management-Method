#! /bin/bash

if [ $# -ne 11 ]; then
	echo "You should supply"
	echo "For Server Migration"
	echo "1. Target IP address(ex. 163.152.161.167)"
	echo "2. Target User ID"
	echo ""
	
	echo "For Core Migration"
	echo "3: thermal threshold"
        echo "4: 1st virtual machine name"
        echo "5: 1st pcpu number"
        echo "6: 2nd virtual machine name"
        echo "7: 2nd pcpu number"
        echo "8: thermal check period"
        echo "9: first max_perf_pct"
        echo "10: last max_perf_pct"
	echo ""
	
	echo "For DVFS Method"
	echo "11. Target Frequency (ex. 35(3.5GHz))"

	exit 2
fi

while [ $# -gt 0 ]
do
	current_MPI=(`cat /home/seunghun/Desktop/Server1_state`)
	
	current_temp=(`cat /sys/class/hwmon/hwmon0/temp1_input`)
        current_temp=$(($current_temp/1000))
	
	if [ $current_temp -ge 80 ]; then	
		if (( $(echo "$current_MPI > 0.001" |bc -l) )); then
			./server_migration.sh $1 $2
			break
		elif (( $(echo "$current_MPI > 0.0005" |bc -l) )); then
			./core_migration.sh $3 $4 $5 $6 $7 $8 $9 $10
			break
		else
			./dvfs.sh $11i
			break
		fi
	fi
	sleep 0.2
done
