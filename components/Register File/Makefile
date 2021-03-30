SOURCES = $(wildcard *tb.v)
SIMFILE = main.vcd


resim : $(SOURCES)
	iverilog -o ./build/main.out $^
	vvp ./build/main.out 

.PHONY : sim
sim :	$(SOURCES)
	iverilog -o ./build/main.out $^
	vvp ./build/main.out
	gtkwave ./build/$(SIMFILE)

.PHONY : clean
clean : 
	rm ./build/*

build: 
	mkdir build