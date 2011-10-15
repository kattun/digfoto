module digifoto
(
	input CLK,
	input RST_X,
	input SD_DO_7,

	output RGB_R,
	output RGB_G,
	output RGB_B,
	output HSYNC,
	output YSYNC,
	output SD_CS_1,
	output SD_DI_2,
	output SD_GND_3,
	output SD_VCC_4,
	output SD_CLK_5,
	output SD_GND_6
);

wire        wr_sdrd_dsp;
wire [63:0] data_sdrd_dsp;

module sdrd_top
(
	.CLK(CLK),
	.RST_X(RST_X),
	.DO  (SD_DO_7 ),

	.WR  (wr_sdrd_dsp),
	.DATA(data_sdrd_dsp),
	.CS  (SD_CS_1 ),
	.DI  (SD_DI_2 ),
	.GND (SD_GND_3),
	.VCC (SD_VCC_4),
	.CLK (SD_CLK_5),
	.GND (SD_GND_6)
);

module dsp_top
(
	.CLK            (CLK),
	.RST_X          (RST_X),
	.WR             (wr_sdrd_dsp),
	.DATA           (data_sdrd_dsp),

	.RGB_R          (RGB_R),
	.RGB_G          (RGB_G),
	.RGB_B          (RGB_B),
	.HSYNC          (HSYNC),
	.YSYNC          (YSYNC)
);

endmodule

