`include "../multicycle/multicycle.v"
module top(
  input CLK, //16Mhz
 output USBPU,
 output LED,

    output PIN_14,   
    output PIN_15,   
    output PIN_16,   
    output PIN_17,   

    output PIN_18,   
    output PIN_19,   
    output PIN_20,   
    output PIN_21

);
    assign USBPU = 0; //disable USB

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

assign hsCLK = clkCounter[22];// ticks every half second
assign LED = hsCLK;



always @(posedge hsCLK) begin
  onesDigit <= onesDigit +2 ;
end



endmodule