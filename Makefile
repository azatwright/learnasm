all:

maximum: maximum.s
	as -o maximum.o maximum.s
	ld -o maximum maximum.o

jump: jump.s
	as -o jump.o jump.s
	ld -o jump jump.o

hello: hello.s
	as -o hello.o hello.s
	ld -o hello hello.o

clean:
	rm -f maximum maximum.o
	rm -f jump jump.o
	rm -f hello hello.o