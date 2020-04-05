IDIR=../include

CC = cc
CFLAGS = -Wall -g -I$(IDIR)

program: flex
	$(CC) $(CFLAGS) -o program main.c lib/*.c -ll

flex:
	flex -o main.c tp1.fl

clean:
	rm program
	rm main.c
