#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <time.h> 
#include <pthread.h>

static int msg_size = 0;
static int listenfd = 0;

void sig_handler(int signo) {
    printf("ternimates in sig_handler.\n");
    close(listenfd);
    exit(0);
}

static void *socket_thread(void *arg){
    char *buf = malloc(msg_size);
    int connfd = *(int *) arg;
    while (1) {
	int remain = msg_size;
	while (remain > 0 ) {
	    int ret = recv(connfd, buf, remain, 0);
	    if (ret <= 0) {
		printf("server recv error %d\n", ret);
	        close(connfd);
	        return NULL;
	    }
	    remain -= ret;
	}
	
	remain = msg_size;
	while (remain > 0) {    
	    int ret = send(connfd, buf, remain, 0);
	    if (ret <= 0) {
		printf("server send error %d\n", ret);
                close(connfd);
            	return NULL;
            }
	    remain -= ret;
	}
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
	printf("server [msg_size]\n");
	return -1;
    }
    
    msg_size = atoi(argv[1]);
    printf("msg_size = %d\n", msg_size);
    int connfd = 0;
    struct sockaddr_in serv_addr; 

    listenfd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&serv_addr, '0', sizeof(serv_addr));

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(5000); 

    bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr)); 

    listen(listenfd, 10); 

    while (1) {
        connfd = accept(listenfd, (struct sockaddr*)NULL, NULL); 
	int *tmp = malloc(sizeof(int));
	*tmp = connfd;
	pthread_t pid;
	pthread_create(&pid, NULL, socket_thread, tmp);
    }
}

