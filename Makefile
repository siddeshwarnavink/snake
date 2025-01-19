build:
		gcc -nostartfiles -no-pie -c -o snake.o snake.s -g
		gcc -nostartfiles -no-pie -c -o keyboard_input.o keyboard_input.s -g
		gcc -nostartfiles -no-pie -c -o box.o box.s -g
		gcc -nostartfiles -no-pie -o snake snake.o keyboard_input.o box.o -lncurses

clean:
		rm -f snake *.o

.PHONY: build clean
