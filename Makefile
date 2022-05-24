objects = maximum jump hello power factorial

all:

$(objects): %: %.s
	as -o $@.o $<
	ld -o $@ $@.o

%: %.s
	as -o $@.o $<
	ld -o $@ $@.o

clean:
	rm -f $(objects)
	rm -f $(foreach obj,$(objects),$(obj).o)