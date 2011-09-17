module basysTest
(
        input           CLK,
        input  [3:0]    BTN,

        output [6:0]    SEG,
        output [3:0]    AN,
        output          DP
);

wire        RST_X               = ~BTN[0];

assign AN  = BTN;
assign DP = 0;

reg [7:0] tcount;
reg [31:0] count;

parameter MAX = 50*1024*1024;

always @(posedge CLK or negedge RST_X) begin
        if( !RST_X )
                tcount <= 8'b0;
        else if( tcount == 8'b0000_0100 && count == MAX)
                tcount <= 0;
        else if( count == MAX )
                tcount <= tcount + 8'b1;
end

always @(posedge CLK or negedge RST_X) begin
        if( !RST_X )
                count <= 31'b0;
        else if(count > MAX )
                count <= 31'b0;
        else
                count <= count + 31'b1;
end

reg [6:0] r_seg;
always @* begin
        case(tcount)
                8'b0000_0001:   r_seg <= 7'b111_1001;
                8'b0000_0010:   r_seg <= 7'b010_0100;
                8'b0000_0011:   r_seg <= 7'b011_0000;
                8'b0000_0100:   r_seg <= 7'b011_0000;
                default:        r_seg <= 7'b100_0000;
        endcase
end

assign SEG = r_seg;
endmodule
