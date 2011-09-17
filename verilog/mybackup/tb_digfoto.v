/*---auto creating---*/
`timescale 1ns/10ps
module tb_digfoto;
/*----------------------------------------------------------------*/
/* parameters */
/*----------------------------------------------------------------*/
parameter P_CYCLE_CLK = 20;
parameter STB = 1;
parameter outfile = "output.txt";

/*----------------------------------------------------------------*/
/* regsters */
/*----------------------------------------------------------------*/
integer i;
reg [47:0] rCmd;

/*----------------------------------------------------------------*/
/* regs and wires */
/*----------------------------------------------------------------*/
reg        	r_clk;
reg [3:0]	r_btn;
wire [6:0]	w_seg;
wire [3:0]	w_an;
wire        	w_dp;
wire        	w_sd_cs_1;
wire        	w_sd_di_2;
wire        	w_sd_clk_5;
wire        	w_sd_do_7;

wire		w_di;
wire        	w_gnd1;
wire        	w_vcc;
wire        	w_sclk;
wire        	w_gnd2;
/*----------------------------------------------------------------*/
/* testmodule */
/*----------------------------------------------------------------*/
digfoto u_digfoto
(
        .CLK(r_clk),
        .BTN(r_btn),
        .SD_DO_7(w_sd_do_7),
        .SEG(w_seg),
        .AN(w_an),
        .DP(w_dp),
        .SD_CS_1(w_sd_cs_1),
        .SD_DI_2(w_sd_di_2),
        .SD_CLK_5(w_sd_clk_5)
);

tb_sdcard u_tb_sdcard
(
        .CS(w_sd_cs_1),
        .DI(w_sd_di_2),
        .GND1(1'b0),
        .VCC(1'b1),
        .CLK(r_clk),
        .GND2(1'b0),
        .DO(w_sd_do_7)
);
/*----------------------------------------------------------------*/
/* generate clk */
/*----------------------------------------------------------------*/
always begin
        #(P_CYCLE_CLK/2) r_clk = ~r_clk;
end

always @(posedge r_clk or posedge r_btn[0]) begin
        if (r_btn)
                rCmd <= 0;
        else
                rCmd[47:0] <= {rCmd[46:0], w_sd_di_2};
end

// spictrlから正しいコマンド出力が来ているかを判定
always @(posedge r_clk) begin
        case(rCmd[47:0])
                u_digfoto.u_sdrd.u_spi.wire_CMD0: $display("CMD0 detect!\n");
                u_digfoto.u_sdrd.u_spi.wire_CMD1: $display("CMD1 detect!\n");
                u_digfoto.u_sdrd.u_spi.wire_CMD17: $display("CMD17 detect!\n");
        endcase
end
/*----------------------------------------------------------------*/
/* body */
/*----------------------------------------------------------------*/
/*---auto created ---*/
initial begin
        r_clk = 0;
        r_btn = 0;
        #(STB)
        r_btn = 1;
        #(P_CYCLE_CLK)
        r_btn = 0;

end
endmodule
