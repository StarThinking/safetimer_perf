CC = gcc

CFLAGS = -Wall -ggdb

all: client server

client: client.o
	$(CC) $(CFLAGS) -o $@ $^ 

server: server.o
	$(CC) $(CFLAGS) -o $@ $^ -lrt -lpthread 

%.o: %.c
	$(CC) $< $(CFLAGS) -c -o $@

clean:
	rm *.o client server

.PHONY: clean
