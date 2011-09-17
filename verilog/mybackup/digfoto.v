module digfoto
(
        input           CLK,
        input  [3:0]    BTN,
        input           SD_DO_7,

        output [6:0]    SEG,
        output [3:0]    AN,
        output          DP,
//         output [2:0]    RGB_R,
//         output [2:0]    RGB_G,
//         output [2:1]    RGB_B,
//         output          HSYNC,
//         output          VSYNC,
        output          SD_CS_1,
        output          SD_DI_2,
        output          SD_CLK_5
);


wire        RST_X               = ~BTN[0];
assign AN = BTN;
assign DP = 0;

wire        wr_sdrd_dsp;
wire [63:0] data_sdrd_dsp;
wire [3:0] dbg;

sdrd_top u_sdrd
(
        .CLK(CLK),
        .RST_X(RST_X),
        .SD_DO_7  (SD_DO_7 ),

        .WR  (wr_sdrd_dsp),
        .DATA(data_sdrd_dsp),
        .SD_CS_1  (SD_CS_1 ),
        .SD_DI_2  (SD_DI_2 ),
        .SD_GND_3 (SD_GND_3),
        .SD_VCC_4 (SD_VCC_4),
        .SD_CLK_5 (SD_CLK_5),
        .SD_GND_6 (SD_GND_6),
        .DEBUG(dbg)
);

// dsp_top u_dsp
// (
//         .CLK            (CLK),
//         .RST_X          (RST_X),
//         .WR             (wr_sdrd_dsp),
//         .DATA           (data_sdrd_dsp),
// 
//         .RGB_R          (RGB_R),
//         .RGB_G          (RGB_G),
//         .RGB_B          (RGB_B),
//         .HSYNC          (HSYNC),
//         .VSYNC          (VSYNC)
// );

// for debug - - -
// reg         csCheck;
// 
// always @ (posedge CLK or negedge RST_X) begin
//         if( !RST_X )
//                 csCheck <= 1'b0;
//         else if(SD_CS_1 == 1'b0)
//                 csCheck <= 1'b1;
// end

// assign dbg = {SD_DO_7, SD_CLK_5, SD_DI_2, SD_CS_1};
// assign dbg = {3'b0, SD_DO_7};
function [6:0] dec;
        input [3:0] in;
        case(in)
                4'b0001:   dec = 7'b111_1001;
                4'b0010:   dec = 7'b010_0100;
                4'b0011:   dec = 7'b011_0000;
                4'b0100:   dec = 7'b011_0000;
                4'b0101:   dec = 7'b0010010;
                4'b0110:   dec = 7'b0000010;
                4'b0111:   dec = 7'b1111000;
                4'b1000:   dec = 7'b0000000;
                4'b1001:   dec = 7'b0010000;
                4'b1010:   dec = 7'b0001000;
                4'b1011:   dec = 7'b0000011;
                4'b1100:   dec = 7'b1000110;
                4'b1101:   dec = 7'b0100001;
                4'b1110:   dec = 7'b0000110;
                4'b1111:   dec = 7'b0001110;
                default:   dec = 7'b100_0000;
        endcase
endfunction

assign SEG = dec(dbg);

endmodule

