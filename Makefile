objects = maximum.o jump.o hello.o

all: $(objects)

$(objects): %.o: %.s
	as -o $@ $<
	ld -o $* $@

clean:
	rm -f maximum maximum.o
	rm -f jump jump.o
	rm -f hello hello.o