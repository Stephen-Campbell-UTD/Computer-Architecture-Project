SOURCES = $(wildcard *tb.v)
SIMFILE = main.vcd


resim : $(SOURCES) build
	iverilog -o ./build/main.out $^
	vvp ./build/main.out 

.PHONY : sim
sim :	$(SOURCES) build
	iverilog -o ./build/main.out $^
	vvp ./build/main.out
	gtkwave ./build/$(SIMFILE)

.PHONY : clean 
clean : build
	rm ./build/*

build: 
	mkdir build