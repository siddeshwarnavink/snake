AFLAG = -nostartfiles -no-pie -g

build:
		gcc $(AFLAG) -c -o game.o game.s
		gcc $(AFLAG) -c -o keyboard_input.o keyboard_input.s
		gcc $(AFLAG) -c -o box.o box.s
		gcc $(AFLAG) -c -o food.o food.s
		gcc $(AFLAG) -c -o snake.o snake.s
		gcc -nostartfiles -no-pie -o snake game.o keyboard_input.o box.o food.o snake.o -lncurses

clean:
		rm -f snake *.o

.PHONY: build clean
