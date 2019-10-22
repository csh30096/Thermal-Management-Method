#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <inttypes.h>
#include <string.h>


void cpu_temp_write(FILE *);

int main(int args, char *argv[]){
	
	FILE *fp;
	char output[1000]="/home/seunghun/Desktop/temper";

	while(1){
		usleep(100000);
		fp = fopen(output, "w");
		cpu_temp_write(fp);
		fclose(fp);
	}

	return 0;

}

void cpu_temp_write(FILE *fp){
	uint64_t data;
	uint32_t reg = strtoul("412", NULL, 0);
	unsigned int bits = 7; // 22-16+1
	unsigned int highbit = 22, lowbit = 16;
	int i, fd;	
	for(i = 0; i < 4; i++){
		char read_file[100];
		sprintf(read_file, "/dev/cpu/%d/msr", i);
		fd = open(read_file, O_RDONLY);
		pread(fd, &data, sizeof data, reg);
		close(fd);
		data >>= lowbit;
		data &= (1ULL << bits) -1;
		if (data & (1ULL << (bits - 1))) {
			data &= ~(1ULL << (bits - 1));
			data = -data;
		}
		if((long long int) data < 2){
			fprintf(fp,"%lld ", (30-(long long int)data));
		}
		else{
			fprintf(fp,"%lld ", (100 - (long long int)data));
		}
	}
}
