results = create-records

.INTERMEDIATE: common.o $(foreach r,$(results),$(r).o)

all: $(results)

%.o: %.s
	as -o $@ $<

$(results): %: %.o common.o def.s
	ld -o $@ $< common.o

clean:
	rm -f $(results)
	rm -f records.bin