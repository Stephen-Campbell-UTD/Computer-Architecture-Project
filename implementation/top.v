`include "../multicycle/multicycle.v"
// `include "../components/RAM/RAM.v"

module top (
    input  CLK,  //16Mhz
    output USBPU,
    output LED,

    input PIN_1,
    input PIN_2,
    input PIN_3,
    input PIN_4,
    input PIN_5,
    input PIN_6,
    input PIN_7,
    input PIN_8,

    // output PIN_9,
    // output PIN_10,
    // output PIN_11,
    // output PIN_12,


    input PIN_13,

    output PIN_14,
    output PIN_15,
    output PIN_16,
    output PIN_17,

    output PIN_18,
    output PIN_19,
    output PIN_20,
    output PIN_21

);

  assign USBPU = 0;  //disable USB

  reg [3:0] onesDigit;
  assign PIN_14 = onesDigit[0];
  assign PIN_15 = onesDigit[1];
  assign PIN_16 = onesDigit[2];
  assign PIN_17 = onesDigit[3];

  reg [3:0] tensDigit;
  assign PIN_18 = tensDigit[0];
  assign PIN_19 = tensDigit[1];
  assign PIN_20 = tensDigit[2];
  assign PIN_21 = tensDigit[3];


  reg [22:0] clkCounter;
  wire hsCLK;

  always @(posedge CLK) begin
    clkCounter <= clkCounter + 1;
  end

  assign hsCLK = clkCounter[22];  // ticks every half second

  wire [10:0] debugAddress;
  assign debugAddress = {3'b000, PIN_1, PIN_2, PIN_3, PIN_4, PIN_5, PIN_6, PIN_7, PIN_8};


  wire reset;
  assign reset = PIN_13;

  assign LED   = hsCLK || reset;


  wire [7:0] debugOut;
  // wire [3:0] controlState;
  // assign PIN_9  = controlState[0];
  // assign PIN_10 = controlState[1];
  // assign PIN_11 = controlState[2];
  // assign PIN_12 = controlState[3];

  // Multicycle mc (
  //     .clk(hsCLK),
  //     .reset(reset),
  //     .debugAddress(debugAddress),
  //     .debugMemOut(debugOut)
  //     // .controlState(controlState)
  // );

  // defparam mc.ram.MEM_DEPTH = 48;

  RAM ram (
      .reset(reset),
      .debugAddress(debugAddress),
      .debugOut(debugOut)
      // .isReading(1'b1),
      // .dataOut(dataOut)
  );
  defparam ram.MEM_DEPTH = 40;

  always @* begin
    onesDigit <= debugOut[3:0];
    tensDigit <= debugOut[7:4];
  end



endmodule

