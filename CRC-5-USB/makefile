.PHONY: wave

all: transmitter.sv receiver.sv calc.sv test/test.sv
	iverilog -g2012 $^
	a.out
	rm a.out

wave: dump.vcd
	gtkwave dump.vcd
