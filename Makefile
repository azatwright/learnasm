asmresults = maximum jump hello power factorial

all:

%: %.s
	as -o $@.o $<
	ld -o $@ $@.o

clean:
	rm -f $(asmresults)
	rm -f $(foreach result,$(asmresults),$(result).o)