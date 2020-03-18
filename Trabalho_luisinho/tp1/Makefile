CFLAGS = -std=c11 -g `pkg-config --cflags libxml-2.0` `pkg-config --cflags glib-2.0` -I

tp1: tp1.fl
	flex tp1.fl
	cc `pkg-config --cflags --libs glib-2.0` -o tp1  lex.yy.c src/*.c
clean:
	rm -f tp1