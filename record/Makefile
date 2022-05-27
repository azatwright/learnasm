results = create-records
commons = common.o
objects = $(commons) $(foreach r,$(results),$(r).o)

all: $(results)

$(objects): %.o: %.s def.s
	as -o $@ $<

$(results): %: %.o $(commons)
	ld -o $@ $< $(commons)

clean:
	rm -f $(results) $(objects)
	rm -f records.bin