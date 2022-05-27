asmresults = maximum jump hello power factorial tolower assembly-symbol
asmobjects = $(foreach ar,$(asmresults),$(ar).o)

.INTERMEDIATE: $(asmobjects)

all:

$(asmobjects): %.o: %.s
	as -o $@ $<

$(asmresults): %: %.o
	ld -o $@ $<

clean:
	rm -f $(asmresults)