results = create-records

.INTERMEDIATE: common.o $(foreach r,$(results),$(r).o)

all: $(results)

%.o: %.s def.s
	as -o $@ $<

$(results): %: %.o common.o
	ld -o $@ $< common.o

clean:
	rm -f $(results)
	rm -f records.bin