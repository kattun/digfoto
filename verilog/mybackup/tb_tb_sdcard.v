/*---auto creating---*/
`timescale 1ns/10ps
module tb_tb_sdcard;
/*----------------------------------------------------------------*/
/* parameters */
/*----------------------------------------------------------------*/
parameter P_CYCLE_CLK = 10;
parameter STB = 1;
parameter outfile = "output.txt";

/*----------------------------------------------------------------*/
/* regsters */
/*----------------------------------------------------------------*/
integer i;

/*----------------------------------------------------------------*/
/* regs and wires */
/*----------------------------------------------------------------*/
  reg        	r_cs;
  reg        	r_di;
  reg        	r_gnd1;
  reg        	r_vcc;
  reg        	r_clk;
  reg        	r_gnd2;

/*----------------------------------------------------------------*/
/* testmodule */
/*----------------------------------------------------------------*/
tb_sdcard u_tb_sdcard
(
  .CS(r_cs),
  .DI(r_di),
  .GND1(r_gnd1),
  .VCC(r_vcc),
  .CLK(r_clk),
  .GND2(r_gnd2),
  .DO(w_do)
);

/*----------------------------------------------------------------*/
/* generate clk */
/*----------------------------------------------------------------*/
always begin
#(P_CYCLE_CLK/2) r_clk = ~r_clk;
end

/*----------------------------------------------------------------*/
/* body */
/*----------------------------------------------------------------*/
initial begin
  r_cs = 0;
  r_di = 0;
  r_gnd1 = 0;
  r_vcc = 0;
  r_clk = 0;
  r_gnd2 = 0;
#(STB)
/*---auto created ---*/
