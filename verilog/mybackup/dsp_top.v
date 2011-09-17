module dsp_top
(
        input           CLK,
        input           RST_X,
        input           WR,
        input   [63:0]  DATA,

        output  [2:0]   RGB_R,
        output  [2:0]   RGB_G,
        output  [1:0]   RGB_B,
        output          HSYNC,
        output          VSYNC
);

assign RGB_R = 0;
assign RGB_G = 0;
assign RGB_B = 0;
assign HSYNC = 0;
assign VSYNC = 0;
endmodule
