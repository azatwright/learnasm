results = create-records read-records sub-age
commons = common.o lib.o linux_64_syscall.o
objects = $(commons) $(foreach r,$(results),$(r).o)

all: $(results)

$(objects): %.o: %.s def.s
	as -o $@ $<

$(results): %: %.o $(commons)
	ld -o $@ $< $(commons)

clean:
	rm -f $(results) $(objects)
	rm -f records.bin
