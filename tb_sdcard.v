`timescale 1ns/10ps
module tb_sdcard
(
 input          CS,
 input          DI,
 input          GND1,
 input          VCC,
 input          CLK,
 input          GND2,
 output         DO
 );
/*----------------------------------*/
/* parameters */
/*----------------------------------*/
parameter INIT          = 0;
parameter MMC_MODE      = 1;
parameter IDLE          = 2;

/*----------------------------------*/
/* integers */
/*----------------------------------*/
/*----------------------------------*/
/* regs and wires */
/*----------------------------------*/
// satate machine
reg     [2:0]   current, next;

// controll wire
wire            initialized;

// buffer
reg     [47:0]  bufer_DI;
reg     [5:0]   buffer_cmd;
reg     [31:0]  buffer_arg;
reg     [6:0]  buffer_crc;

// counter
reg     [9:0]   count_CS;

// debug
reg            error;
/*----------------------------------*/
/* body */
/*----------------------------------*/
//count_CS
always @(posedge CLK) begin
        if(CS == 1'b0)
                count_CS <= 10'b0;
        else if(CS == 1'b1)
                count_CS <= count_CS + 10'b1;
end
//----------------------------------------------
// state machine
//----------------------------------------------
always @ (posedge CLK) current <= next;

always @* begin
        case(current)
                INIT: begin
                        if(count_CS >= 10'd74)
                                next <= MMC_MODE;
                        else
                                next <= INIT;
                end
                MMC_MODE: begin
                        if( initialized )
                                next <= IDLE;
                        else
                                next <= MMC_MODE;
                end
                IDLE: begin
                        next <= IDLE;
                end
                default: begin
                        error <= 1'b1;
                end
        endcase
end

//----------------------------------------------
//buffer
//----------------------------------------------
// bufer_DI
always @ (posedge CLK) begin
        if(currnet == IDLE) begin
                bufer_DI    = bufer_DI << 1;
                bufer_DI[0] = DI;
        end
end

always @ (posedge CLK) begin
        if(bufer_DI[47:46] == 2'b01 && bufer_DI[0] == 1'b1) begin
                buffer_cmd[5:0] <=  bufer_DI[45:40]
                buffer_arg[31:0] <= bufer_DI[39:8]
                buffer_crc[6:0] <=  bufer_DI[7:1]
        end
        else begin
                buffer_cmd <= 6'b111111;
        end
end

assign initialized = ~( (&buffer_cmd) & (&buffer_arg) );

always @* begin
        case(buffer_cmd)
        0:       buffer_DO <= 8'b0000_0001;
        1:       buffer_DO <= 8'b0000_0000;
        default: buffer_DO <= 8'b1111_1111;
        endcase
end

always @(posedge CLK) begin
        DO = buffer_DO[7];
        buffer_DO[7:1] = buffer_DO << 1;
end

endmodule
