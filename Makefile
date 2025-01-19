build:
		gcc -nostartfiles -no-pie -c -o snake.o snake.s -g
		gcc -nostartfiles -no-pie -c -o keyboard_input.o keyboard_input.s -g
		gcc -nostartfiles -no-pie -o snake snake.o keyboard_input.o -lncurses

clean:
		rm -f snake snake.o keyboard_input.o

.PHONY: build clean
