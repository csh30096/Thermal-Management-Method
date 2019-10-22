#! /bin/bash
if [ $# -ne 1 ]; then
        echo "You should supply"
        echo "1. Target Frequency"
        echo "Ex. 35(3.5GHz)"
fi

max_freq_path="/sys/devices/system/cpu/intel_pstate/max_perf_pct"

while [ $# -gt 0 ]
do
        current_temp=(`cat /sys/class/hwmon/hwmon0/temp1_input`)
        current_temp=$(($current_temp/1000))
        if [ $current_temp -ge 80 ]; then
                python MLP_freq.py $1
		Target_F=(`cat /home/seunghun/Desktop/predict_freq`)
		echo $Target_F > $max_freq_path
                break
        fi
        sleep 1
done

