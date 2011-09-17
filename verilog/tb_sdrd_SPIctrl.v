`timescale 1ns/10ps
module tb_sdrd_SPIctrl;
/*----------------------------------*/
/* parameters */
/*----------------------------------*/
parameter P_CYCLE_CLK = 10;
parameter STB = 1;
parameter outfile = "output.txt";

/*----------------------------------*/
/* regsters */
/*----------------------------------*/

/*----------------------------------*/
/* regs and wires */
/*----------------------------------*/
  reg        	r_clk;
  reg        	r_rst_x;
  reg [31:0]	r_spin_access_adr;
  reg [1:0]	   r_spin_datatype;
  reg        	r_do;
  wire        	w_spi_busy;
  wire        	w_spi_init;
  wire [255:0] w_spiout_fatprm;
  wire			w_spiout_fat_valid;
  wire			w_spiout_rgbwr;
  wire [63:0]	w_spiout_rgbdata;
  wire			w_cs;
  wire			w_di;
  wire        	w_gnd1;
  wire        	w_vcc;
  wire        	w_sclk;
  wire        	w_gnd2;

/*----------------------------------*/
/* testmodule */
/*----------------------------------*/
sdrd_SPIctrl u_sdrd_SPIctrl
(
  .CLK                  (r_clk),
  .RST_X                (r_rst_x),
  .SPIN_ACCESS_ADR      (r_spin_access_adr),
  .SPIN_DATATYPE        (r_spin_datatype),
  .DO                   (w_do),
  .SPI_BUSY             (w_spi_busy),
  .SPI_INIT             (w_spi_init),
  .SPIOUT_FATPRM        (w_spiout_fatprm),
  .SPIOUT_FAT_VALID     (w_spiout_fat_valid),
  .SPIOUT_RGBWR         (w_spiout_rgbwr),
  .SPIOUT_RGBDATA       (w_spiout_rgbdata),
  .CS                   (w_cs),
  .DI                   (w_di),
  .GND1                 (w_gnd1),
  .VCC                  (w_vcc),
  .SCLK                 (w_sclk),
  .GND2                 (w_gnd2)
);

tb_sdcard sdcard
(
	.CS	(w_cs	),
	.DI	(w_di	),
	.GND1	(w_gnd1),
	.VCC	(w_vcc),
	.CLK	(w_sclk),
	.GND2	(w_gnd2),
	.DO	(w_do)
	);

/*----------------------------------*/
/* generate clk */
/*----------------------------------*/
always begin
#(P_CYCLE_CLK/2) r_clk = ~r_clk;
end

/*----------------------------------*/
/* body */
/*----------------------------------*/
initial begin
  r_clk = 0;
  r_rst_x = 0;
  r_spin_access_adr = 0;
  r_spin_datatype = 0;
  r_do = 0;
#(STB)
  r_rst_x = 1;

#(P_CYCLE_CLK)
  r_spin_access_adr  = 32'h00;
  r_spin_datatype    = 2'd2;
end

endmodule
