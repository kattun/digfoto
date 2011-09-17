module sdrd_FAT32ctrl
(
        input           CLK,
        input           RST_X,
        input           SPI_BUSY,
        input           SPI_INIT,
        input   [255:0] FATIN_PRM,
        input           FATIN_VALID,
        output  [31:0]  FATOUT_ACCESS_ADR,
        output  [1:0]   FATOUT_DATATYPE
);


/* --------------------------------------------------------------- */
/* prm, reg, wire */
/* --------------------------------------------------------------- */
/*  state machine parameter */
parameter       INIT            =       0;
parameter       GET_BPB         =       1;
parameter       SET_BPB         =       2;
parameter       GET_ROOTDIR     =       3;
parameter       SET_DIGFOTODIR  =       4;
parameter       GET_DIGFOTODIR  =       5;
parameter       SET_FOTO        =       6;
parameter       GET_DATA        =       7;

/*  state machine */
reg     [4:0]   current, next;

/*  state control */
wire            BPBdata_received;
wire            BPB_configured;
wire            rootDir_received;
wire            DigFotoDir_configured;
wire            DigFotoDir_received;
wire            fotoEntry_pushed;

/*  fifo */
/*  entrance */
wire    [255:0] entrance_fifo_din  ; 
wire            entrance_fifo_wr   ; 
wire            entrance_fifo_rd   ; 
wire            entrance_fifo_full ; 
wire            entrance_fifo_empty; 
wire            entrance_fifo_valid; 
// BPBパラメタが一度に読み込めるよう512bitに拡張
wire    [511:0] entrance_fifo_dout ; 

/*  pictureEntry */
wire    [31:0]  pictureEntry_fifo_din  ; 
wire            pictureEntry_fifo_wr   ; 
wire            pictureEntry_fifo_rd   ; 
wire            pictureEntry_fifo_full ; 
wire            pictureEntry_fifo_empty; 
wire            pictureEntry_fifo_valid; 
wire    [31:0]  pictureEntry_fifo_dout ; 

/* --------------------------------------------------------------- */
/*  input */
/* --------------------------------------------------------------- */
assign entrance_fifo_din   = FATIN_PRM;
assign entrance_fifo_wr    = 
assign entrance_fifo_rd    = 
assign entrance_fifo_full  = 
assign entrance_fifo_empty = 
assign entrance_fifo_valid = 
assign entrance_fifo_dout  = 







wire            pvalid;
module
(
        .CLK(CLK),
        .RST_X(RST_X),
);

assign entrance_fifo_wr     = pvalid;
/* ---------------------------------------------------------------  */
/*  state machine                                                   */
/* ---------------------------------------------------------------  */
always @ (posedge CLK or negedge RST_X) begin                     
        if( !RST_X )
                current <= INIT;
        else
                current <= next;
end

always @* begin
        case(current)
                : begin
                end
        endcase
end


/* --------------------------------------------------------------- */
/*   */
/* --------------------------------------------------------------- */


/* --------------------------------------------------------------- */
/* output */
/* --------------------------------------------------------------- */

/* --------------------------------------------------------------- */
/* FIFO */
/* --------------------------------------------------------------- */
fifo_fwft_256in256out_1024depth entrance_fifo
(
        .clk            (CLK                    ),
        .rst            (!RST_X                 ),
        .din            (entrance_fifo_din        ),
        .wr_en          (entrance_fifo_wr         ),
        .rd_en          (entrance_fifo_rd         ),
        .full           (entrance_fifo_full       ),
        .empty          (entrance_fifo_empty      ),
        .valid          (entrance_fifo_valid      ),
        .dout           (entrance_fifo_dout       )
);

fifo_fwft_32in32out_1024depth pictureEntry_fifo
(
        .clk            (CLK                    ),
        .rst            (!RST_X                 ),
        .din            (pictureEntry_fifo_din        ),
        .wr_en          (pictureEntry_fifo_wr         ),
        .rd_en          (pictureEntry_fifo_rd         ),
        .full           (pictureEntry_fifo_full       ),
        .empty          (pictureEntry_fifo_empty      ),
        .valid          (pictureEntry_fifo_valid      ),
        .dout           (pictureEntry_fifo_dout       )
);


/* --------------------------------------------------------------- */
/* function */
/* --------------------------------------------------------------- */
function [] BPBdata_selector;
        input 
        input 
        case()
                default : ;
        endcase
endfunction

function [] digFotoEntry_selector;
        input 
        input 
        case()
                default : ;
        endcase
endfunction

function [] pictureEntry_selector;
        input 
        input 
        case()
                default : ;
        endcase
endfunction

module
