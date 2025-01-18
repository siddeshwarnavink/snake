build:
		gcc -nostartfiles -no-pie -c -o snake.o snake.s -g
		gcc -nostartfiles -no-pie -o snake snake.o -lncurses

clean:
		rm -f snake snake.o

.PHONY: build clean
