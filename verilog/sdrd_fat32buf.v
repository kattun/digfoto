module sdrd_FAT32buf
(
  input             CLK,
  input             RSTS,
  input             WR,
  input             RD,
  input   [255:0]    INPUT,
  output             EMPTY,
  output             FULL,
  output   [511:0]    OUTPUT,
  output             VALID
);

/*  fat32 */
wire   [255:0]          do_fat_fifo_din   ;
wire                    do_fat_fifo_wr    ;
wire                    do_fat_fifo_rd    ;
wire                    do_fat_fifo_full  ;
wire                    do_fat_fifo_empty ;
wire                    do_fat_fifo_valid ;
wire   [255:0]          do_fat_fifo_dout  ;

/* fifo */
//fat32 data
assign do_fat_fifo_wr           = WR;
assign do_fat_fifo_din          = INPUT;
assign do_fat_fifo_rd           = RD;
assign do_fat_fifo_full         = FULL;
assign do_fat_fifo_empty        = EMPTY;
assign do_dsp_fifo_valid        = VALID;
assign do_fat_fifo_dout         = OUTPUT;

fifo_normal_256in256out_128depth do_fat_fifo
(
        .clk            (CLK                    ),
        .rst            (RSTS                   ),
        .din            (do_fat_fifo_din        ),
        .wr_en          (do_fat_fifo_wr         ),
        .rd_en          (do_fat_fifo_rd         ),
        .full           (do_fat_fifo_full       ),
        .empty          (do_fat_fifo_empty      ),
        .valid          (do_fat_fifo_valid      ),
        .dout           (do_fat_fifo_dout       )
);

endmodule
