INCLUDES = -I ./includes
SIMFILE = main.vcd
SOURCES = $(wildcard $(SOURCE_DIR)/*_tb.v)



BUILD_CMD = iverilog $(INCLUDES) -grelative-include -o ./build/main.out 
SIM_CMD = vvp ./build/main.out 
	

resim : $(SOURCES)
	$(BUILD_CMD) $^
	$(SIM_CMD) 

.PHONY : sim
sim :	$(SOURCES)
	$(BUILD_CMD) $^
	$(SIM_CMD) 
	gtkwave ./build/$(SIMFILE)

.PHONY : clean
clean : 
	rm ./build/*

build: 
	mkdir build

.PHONY : printS
printS :
	echo $(SOURCES)