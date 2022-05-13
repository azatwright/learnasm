objects = maximum jump hello

all: $(objects)

$(objects): %: %.s
	as -o $@.o $<
	ld -o $@ $@.o

clean:
	rm -f maximum maximum.o
	rm -f jump jump.o
	rm -f hello hello.o