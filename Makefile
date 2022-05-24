objects = maximum jump hello power factorial

all:

%: %.s
	as -o $@.o $<
	ld -o $@ $@.o

clean:
	rm -f $(objects)
	rm -f $(foreach obj,$(objects),$(obj).o)