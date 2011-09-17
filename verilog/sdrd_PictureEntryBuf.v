module sdrd_PictureEntryBuf
(
  input             CLK,
  input             RST_X,
  input             WR,
  input             RD,
  input   [31:0]    INPUT,
  output             EMPTY,
  output             FULL,
  output   [31:0]    OUTPUT,
  output             VALID
);

// readしたデータを再度詰み直す、再帰的なバッファ
// 外部からの書き込みと、呼び出しのタイミングはかぶらせてはいけない。
reg             s_wr;

wire    [31:0]  pictureEntry_fifo_din  ; 
wire            pictureEntry_fifo_wr   ; 
wire            pictureEntry_fifo_rd   ; 
wire            pictureEntry_fifo_full ; 
wire            pictureEntry_fifo_empty; 
wire            pictureEntry_fifo_valid; 
wire    [31:0]  pictureEntry_fifo_dout ; 

assign pictureEntry_fifo_wr           = (WR | s_wr);
assign pictureEntry_fifo_din          = s_wr ? pictureEntry_fifo_dout : INPUT;
assign pictureEntry_fifo_rd           = RD;
assign pictureEntry_fifo_full         = FULL;
assign pictureEntry_fifo_empty        = EMPTY;
assign pictureEntry_fifo_valid        = VALID;
assign pictureEntry_fifo_dout         = OUTPUT;

always @ (posedge CLK or negedge RST_X) begin
  if( !RST_X )
    s_wr <= 0;
  else
    s_wr <= RD;
end
fifo_normal_256in256out_128depth do_fat_fifo
(
        .clk            (CLK                    ),
        .rst            (RSTS                   ),
        .din            (pictureEntry_fifo_din  ),
        .wr_en          (pictureEntry_fifo_wr   ),
        .rd_en          (pictureEntry_fifo_rd   ),
        .full           (pictureEntry_fifo_full ),
        .empty          (pictureEntry_fifo_empty),
        .valid          (pictureEntry_fifo_valid),
        .dout           (pictureEntry_fifo_dout )
);
endmodule
