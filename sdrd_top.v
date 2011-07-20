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
	output          SD_GND_6
);

wire [31:0]     addr_fat32_spi;
wire [31:0]     size_fat32_spi;
wire [1:0]      dataType_fat32_spi;

wire            busy_spi_fat32;
wire            init_spi_fat32;
wire [255:0]    data_spi_fat32;
wire            valid_spi_fat32;

module sdrd_SPIctrl spi
(
        .CLK                    (CLK),
        .RST_X                  (RST_X),
        .SPIN_ACCESS_ADR        (addr_fat32_spi),
        .SPIN_DATATYPE          (dataType_fat32_spi),
        .DO                     (SD_DO_7 ),

        .SPI_BUSY               (busy_spi_fat32),
        .SPI_INIT               (init_spi_fat32),
        .SPIOUT_FATPRM          (data_spi_fat32),
        .SPIOUT_FAT_VALID       (valid_spi_fat32),
        .SPIOUT_RGBWR           (WR),
        .SPIOUT_RGBDATA         (DATA),
        .CS                     (SD_CS_1 ),
        .DI                     (SD_DI_2 ),
        .GND1                   (SD_GND_3),
        .VCC                    (SD_VCC_4),
        .SCLK                   (SD_CLK_5),
        .GND2                   (SD_GND_6)
);

module sdrd_FAT32_ctrl fat32
(
        .CLK                    (CLK),
        .RST_X                  (RST_X),
        .SPI_BUSY               (busy_spi_fat32),
        .SPI_INIT               (init_spi_fat32),
        .FATIN_PRM          (data_spi_fat32),
        .FATIN_SIZE            (size_spi_fat32),

        .FATOUT_ACCESS_ADR      (addr_fat32_spi),
        .FATOUT_ACCESS_SIZE     (size_fat32_spi),
        .FATOUT_DATATYPE        (dataType_fat32_spi)
);
endmodule
