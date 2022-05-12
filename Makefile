all:

maximum: maximum.s
	as -o maximum.o maximum.s
	ld -o maximum maximum.o

jump: jump.s
	as -o jump.o jump.s
	ld -o jump jump.o

clean:
	rm -f maximum maximum.o
	rm -f jump jump.o