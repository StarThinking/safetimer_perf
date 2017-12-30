#include <stdio.h> //printf
#include <string.h>    //strlen
#include <sys/socket.h>    //socket
#include <arpa/inet.h> //inet_addr
#include <time.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <unistd.h>
#include <error.h>

static long profiling = 1000;
static long samples[500000];
static long sample_count;
static long sum_latency;

long current_time() {
    struct timespec spec;

    clock_gettime(CLOCK_REALTIME, &spec);
    return spec.tv_sec * 1000000 + spec.tv_nsec/1.0e3;
}
 
int main(int argc , char *argv[]) {

    if (argc != 4) {
	printf("client [ip] [msg_size] [time in us]\n");
	return -1;
    }
    char *ip = argv[1];
    int msg_size = atoi(argv[2]);
    int time = atoi(argv[3]);
    //printf("ip=%s, msg_size=%d, time=%d\n", ip, msg_size, time);

    int sock;
    struct sockaddr_in server;
    char *buf = malloc(msg_size); 

    sock = socket(AF_INET , SOCK_STREAM , 0);
    if (sock == -1) {
        printf("Could not create socket");
    }
    //puts("Socket created");
     
    server.sin_addr.s_addr = inet_addr(ip);
    server.sin_family = AF_INET;
    server.sin_port = htons(5000);

    if (connect(sock , (struct sockaddr *)&server , sizeof(server)) < 0) {
        perror("connect failed. Error");
        return 1;
    }
     
    //puts("Connected\n");

    long start_time = current_time();
    long count = 0;

    while(current_time()-start_time < time) {  
	int remain = msg_size;
        long send_t;

        if ((count % profiling) == 0) 
            send_t = current_time();
	
        while (remain > 0) {
            int ret = send(sock, buf, remain, 0);
            if (ret <= 0) {
		printf("error send %d\n", ret);
            	return -1;
            }
	    remain -= ret;
	}
        //if(ret != msg_size) printf("warning write ret=%d\n", ret);
        remain = msg_size;
	while (remain > 0) {
	    int ret = recv(sock, buf, remain, 0);
            if (ret <= 0) {
		printf("error recv %d\n", ret);
            	return -1;
            }
	    remain -= ret;
	}
        //if(ret != msg_size) printf("warning recv ret=%d\n", ret);
        //printf("count & profiling = %ld\n", count % profiling);
        if ((count % profiling) == 0) {
        //if (1) {
            long recv_t = current_time();
            long used_t = recv_t - send_t;
            samples[sample_count] = used_t;
            sum_latency += used_t;
            sample_count++;
        }
	count ++;
    }
    close(sock);
    
    printf("%f\n", (double)count*(double)msg_size/(double)(current_time()-start_time));
    printf("%f\n", (double)sum_latency/(double)sample_count);
    int i;
    for (i=0; i<sample_count; i++)
        printf("%ld\n", samples[i]);
//    printf("sample_count = %ld, count = %ld\n", sample_count, count);
    
    return 0;
}
