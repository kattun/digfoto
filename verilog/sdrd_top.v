module sdrd_top
(
	input           CLK,
	input           RST_X,
	input           SD_DO_7,

        output          WR,
        output [63:0]  DATA,
	output          SD_CS_1,
	output          SD_DI_2,
	output          SD_GND_3,
	output          SD_VCC_4,
	output          SD_CLK_5,
	output          SD_GND_6,
        output [3:0]    DEBUG
);

wire [31:0]     addr_fat32ctrl_spi;
wire [1:0]      dataType_fat32ctrl_spi;

wire            busy_spi_fat32;
wire            init_spi_fat32;

/* FAT32buf */
wire            rsts_fat32ctrl_fat32buf;
wire            wr_spi_fat32buf;
wire            rd_fat32ctrl_fat32buf;
wire            empty_fat32buf_fat32ctrl;
wire            full_fat32buf_spi;
wire [511:0]    data_fat32buf_fat32ctrl;
wire            valid_fat32buf_fat32ctrl;
wire [255:0]    data_spi_fat32buf;

/*  pictureEntry */
wire            wr_fat32ctrl_pictureEntry;
wire            rd_fat32ctrl_pictureEntry;
wire            empty_pictureEntry_fat32ctrl;
wire            full_pictureEntry_fat32ctrl;
wire [31:0]    data_pictureEntry_spi;
wire            valid_pictureEntry_spi;
wire [31:0]    data_fat32ctrl_pictureEntry;
sdrd_SPIctrl u_spi
(
        .CLK                    (CLK),
        .RST_X                  (RST_X),
        .SPIN_ACCESS_ADR        (addr_fat32ctrl_spi),
        .SPIN_DATATYPE          (dataType_fat32ctrl_spi),
        .BUFFULL                (full_fat32buf_spi),
        .DO                     (SD_DO_7 ),

        .BUSY                   (busy_spi_fat32),
        .INIT                   (init_spi_fat32),
        .FAT32BUF_WR            (wr_spi_fat32buf),
        .FAT32BUF_DATA          (data_spi_fat32buf),
        .CS                     (SD_CS_1 ),
        .DI                     (SD_DI_2 ),
        .GND1                   (SD_GND_3),
        .VCC                    (SD_VCC_4),
        .SCLK                   (SD_CLK_5),
        .GND2                   (SD_GND_6),
        .DEBUG                  (DEBUG)
);

sdrd_FAT32buf u_fat32buf
(
        .CLK                    (CLK),
        .RSTS                   (rsts_fat32ctrl_fat32buf),
        .WR                     (wr_spi_fat32buf),
        .RD                     (rd_fat32ctrl_fat32buf),
        .INPUT                  (data_spi_fat32buf),

        .EMPTY                  (empty_fat32buf_fat32ctrl),
        .FULL                   (full_fat32buf_spi),
        .OUTPUT                 (data_fat32buf_fat32ctrl),
        .VALID                  (valid_fat32buf_fat32ctrl)
);


sdrd_FAT32ctrl u_fat32
(
        .CLK                    (CLK),
        .RST_X                  (RST_X),
        .SPI_BUSY               (busy_spi_fat32),
        .SPI_INIT               (init_spi_fat32),
        .FAT32BUF_EMPTY         (empty_fat32buf_fat32ctrl),
        .PICENTRY_EMPTY         (empty_pictureEntry_fat32ctrl),
        .PICENTRY_FULL          (full_pictureEntry_fat32ctrl),
        .FATIN_PRM              (data_fat32buf_fat32ctrl),
        .FATIN_VALID            (valid_fat32buf_fat32ctrl),

        .FAT32BUF_RD            (rd_fat32ctrl_fat32buf),
        .RSTS                   (rsts_fat32ctrl_fat32buf),
        .PICENTRY_WR            (wr_fat32ctrl_pictureEntry),
        .PICENTRY_DATA          (data_fat32ctrl_pictureEntry),
        .PICENTRY_RD            (rd_fat32ctrl_pictureEntry),
        .FATOUT_ACCESS_ADR      (addr_fat32ctrl_spi),
        .FATOUT_DATATYPE        (dataType_fat32ctrl_spi)
);

sdrd_PictureEntryBuf u_pictureentrybuf
(
        .CLK                    (CLK),
        .RST_X                  (RST_X),
        .WR                     (wr_fat32ctrl_pictureEntry),
        .RD                     (rd_fat32ctrl_pictureEntry),
        .INPUT                  (data_fat32ctrl_pictureEntry),

        .EMPTY                  (empty_pictureEntry_fat32ctrl),
        .FULL                   (full_pictureEntry_fat32ctrl),
        .OUTPUT                 (data_pictureEntry_spi),
        .VALID                  (valid_pictureEntry_spi)
);
endmodule
