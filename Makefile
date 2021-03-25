SOURCES =  $(wildcard *.v)
SIMFILE = main.vcd


sim :	$(SOURCES)
	iverilog -o ./build/main.out $^
	vvp ./build/main.out
	gtkwave ./build/$(SIMFILE)

.PHONY : clean
clean : 
	rm ./build/*

