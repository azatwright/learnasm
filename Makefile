objects = maximum jump hello

all: $(objects)

$(objects): %: %.s
	as -o $@.o $<
	ld -o $@ $@.o

clean:
	rm -f $(objects)
	rm -f $(foreach obj,$(objects),$(obj).o)