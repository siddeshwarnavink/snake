build:
		gcc -nostartfiles -nostdlib -no-pie -c -o snake.o snake.s -g
		gcc -nostartfiles -nostdlib -no-pie -o snake snake.o -lncurses

clean:
		rm -f snake snake.o

.PHONY: build clean
