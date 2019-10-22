#!/bin/bash

# $1: thermal threshold
# $2: 1st virtual machine name
# $3: 1st pcpu
# $4: 2st virtual machine name
# $5: 2st pcpu
# $6: thermal check period
# $7: fir max_perf_pct (ex 85)
# $8: last max_perf_pct (ex 75)

virsh vcpupin $2 0 $3
virsh vcpupin $4 0 $5

fir_core=$3
sec_core=$5
thres=$1
max_freq_file="/sys/devices/system/cpu/intel_pstate/max_perf_pct"

arr=(0 1 2 3)

check=0

if [ $# -lt 8 ]; then
	echo "1: thermal threshold"
	echo "2: 1st virtual machine name"
	echo "3: 1st pcpu number"
	echo "4: 2nd virtual machine name"
	echo "5: 2nd pcpu number"
	echo "6: thermal check period"
	echo "7: first max_perf_pct"
	echo "8: last max_perf_pct"
else
	echo $7 > $max_freq_file

	while [ $# -gt 0 -a $check -le 5 ]
	do
		temp=(`cat /home/seunghun/Desktop/temper`)
		min_fir=0
		min_sec=1
		
		#find min temp core
		for i in ${arr[@]}; do
			if [ ${temp[$i]} -lt ${temp[$min_fir]} ]; then
				min_sec=$min_fir
				min_fir=$i
			elif [ ${temp[$i]} -lt ${temp[$min_sec]} -a $min_fir -ne $i ]; then
				min_sec=$i
			fi
		done 

		#migration or dvfs
		if [ ${temp[$min_fir]} -ge 80 -o ${temp[$fir_core]} -ge 85 -o ${temp[$sec_core]} -ge 85 ]; then
			check=$(($check+1))
			echo "check: $check" 
		else 
			check=0
		fi
		#-->migration

		if [ ${temp[$fir_core]} -ge $thres -a ${temp[$sec_core]} -ge $thres ]; then
			fir_core=$min_fir
			sec_core=$min_sec			
			virsh vcpupin $2 0 $fir_core
			virsh vcpupin $4 0 $sec_core

		elif [ ${temp[$fir_core]} -ge $thres -a $sec_core -ne $min_fir -a $fir_core -ne $min_fir ]; then
			fir_core=$min_fir
			virsh vcpupin $2 0 $fir_core

		elif [ ${temp[$sec_core]} -ge $thres -a $fir_core -ne $min_fir -a $sec_core -ne $min_fir ]; then
			sec_core=$min_fir
			virsh vcpupin $4 0 $sec_core
		fi
		#<--migration


		
		sleep $6
	done

	echo $8 > $max_freq_file
	echo "max_perf_pct is $8"

	while [ $# -gt 0 ]
	do
		temp=(`cat /home/seunghun/Desktop/temper`)
		min_fir=0
		min_sec=1
		
		#find min temp core
		for i in ${arr[@]}; do
			if [ ${temp[$i]} -lt ${temp[$min_fir]} ]; then
				min_sec=$min_fir
				min_fir=$i
			elif [ ${temp[$i]} -lt ${temp[$min_sec]} -a $min_fir -ne $i ]; then
				min_sec=$i
			fi
		done 

		#-->migration

		if [ ${temp[$fir_core]} -ge $thres -a ${temp[$sec_core]} -ge $thres ]; then
			fir_core=$min_fir
			sec_core=$min_sec			
			virsh vcpupin $2 0 $fir_core
			virsh vcpupin $4 0 $sec_core

		elif [ ${temp[$fir_core]} -ge $thres -a $sec_core -ne $min_fir -a $fir_core -ne $min_fir ]; then
			fir_core=$min_fir
			virsh vcpupin $2 0 $fir_core

		elif [ ${temp[$sec_core]} -ge $thres -a $fir_core -ne $min_fir -a $sec_core -ne $min_fir ]; then
			sec_core=$min_fir
			virsh vcpupin $4 0 $sec_core
		fi
		#<--migration
		
		sleep $6
	done

fi
