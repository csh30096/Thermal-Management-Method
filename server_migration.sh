#! /bin/bash

if [ $# -ne 2 ]; then
	echo "You should insert"
	echo "1. Target IP address(ex.163.152.161.167)"
	echo "2. Target User ID"
	exit 2
fi


Mig_IP="$1"

do_mig()
{
	virsh migrate --verbose ${vm_name:0:4} qemu+ssh://$1@$Mig_IP/system --live --migrateuri tcp://$Mig_IP:49152

}


while [ $# -gt 0 ]
do
	current_temp=(`cat /sys/class/hwmon/hwmon0/temp1_input`)
	current_temp=$(($current_temp/1000))
	vm_name=`virsh list | awk '{print$2}'| grep "VM"`
	if [ $current_temp -gt 80 ]; then
		do_mig $2
		break
	fi
	sleep 5

done	
