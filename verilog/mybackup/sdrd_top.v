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


wire            wr_spi_fat32buf;
wire            rd_fat32ctrl_fat32buf;
wire            empty_fat32buf_fat32ctrl;
wire            full_fat32buf_spi;
wire [511:0]    data_fat32buf_fat32ctrl;
wire            valid_fat32buf_fat32ctrl;
wire [255:0]    data_spi_fat32buf;

sdrd_SPIctrl u_spi
(
        .CLK                    (CLK),
        .RST_X                  (RST_X),
        .SPIN_ACCESS_ADR        (addr_fat32ctrl_spi),
        .SPIN_DATATYPE          (dataType_fat32ctrl_spi),
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

sdrd_FAT32buf.v
(
        .CLK                    (CLK),
        .RST_X                  (RST_X),
        .WR                     (wr_spi_fat32buf),
        .RD                     (rd_fat32ctrl_fat32buf),
        .EMPTY                  (empty_fat32buf_fat32ctrl),
        .FULL                   (full_fat32buf_fat32ctrl),
        .INPUT                  (data_spi_fat32buf),
        .OUTPUT                 (data_fat32buf_fat32ctrl),
        .VALID                  (valid_fat32buf_fat32ctrl)
);


sdrd_FAT32ctrl u_fat32
(
        .CLK                    (CLK),
        .RST_X                  (RST_X),
        .SPI_BUSY               (busy_spi_fat32),
        .SPI_INIT               (init_spi_fat32),
        .FATIN_PRM              (data_spi_fat32),
        .FATIN_VALID            (valid_spi_fat32),

        .FATOUT_ACCESS_ADR      (addr_fat32ctrl_spi),
        .FATOUT_DATATYPE        (dataType_fat32ctrl_spi)
);
endmodule
