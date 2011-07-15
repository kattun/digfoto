[]module sdrd_FAT32_ctrl
(
  input       	CLK,
  input       	RST_X,
  input       	SPI_BUSY,
  input       	SPI_INIT,
  input [31:0]	FATIN_PRM,
  input [2:0]	FATIN_SIZE,
  output [31:0]	FATOUT_ACCESS_ADR,
  output [31:0]	FATOUT_ACCESS_SIZE,
  output [1:0]	FATOUT_DATATYPE
);
[]