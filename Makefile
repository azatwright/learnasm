.SUFFIXES:

asmresults = maximum jump hello power factorial tolower assembly-symbol

all:

%.o: %.s
	as -o $@ $<

%: %.o
	ld -o $@ $<

clean:
	rm -f $(asmresults)