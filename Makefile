asmresults = maximum jump hello power factorial tolower assembly-symbol
asmobjects = $(foreach ar,$(asmresults),$(ar).o)
commons = lib.o linux_64_syscall.o

.INTERMEDIATE: $(asmobjects)

all:

$(asmobjects): %.o: %.s
	as -o $@ $<

$(asmresults): %: %.o $(commons)
	ld -o $@ $< $(commons)

clean:
	rm -f $(asmresults) $(commons)
