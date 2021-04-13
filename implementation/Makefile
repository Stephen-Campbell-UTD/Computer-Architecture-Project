TOP_MOD = top
SOURCES = top_tb.v
SIMFILE = main.vcd

BUILD_DIR = build

.PHONY : all
all : $(BUILD_DIR)/$(TOP_MOD).bin 


$(BUILD_DIR)/%.blif : %.v
	yosys -p 'synth_ice40 -top $(TOP_MOD) -blif $@' $^

$(BUILD_DIR)/%.asc : $(BUILD_DIR)/%.blif
	arachne-pnr -d 8k -P cm81 -o $@ -p pins.pcf $^

$(BUILD_DIR)/%.bin : $(BUILD_DIR)/%.asc
	icepack $^ $@

.PHONY: upload
upload: $(BUILD_DIR)/$(TOP_MOD).bin
	tinyprog -p  $^

.PHONY : clean
clean : 
	trash build/*


resim : $(SOURCES)
	iverilog -o ./build/main.out $^
	vvp ./build/main.out 

.PHONY : sim
sim :	$(SOURCES)
	iverilog -o ./build/main.out $^
	vvp ./build/main.out
	gtkwave ./build/$(SIMFILE)