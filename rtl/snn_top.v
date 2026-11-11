`timescale 1ns / 1ps

module snn_top (
    input wire clk,
    input wire rst_n,
    input wire [7:0] f0, f1, f2, f3,
    input wire feature_valid,
    output reg [1:0] command_code, // 00=F, 01=L, 10=R, 11=S
    output reg command_valid
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            command_code  <= 2'b11; // Default STOP
            command_valid <= 1'b0;
        end else if (feature_valid) begin
            command_valid <= 1'b1;
            if (f0 > 8'd100)      command_code <= 2'b00; // FORWARD
            else if (f1 > 8'd100) command_code <= 2'b01; // LEFT
            else if (f2 > 8'd100) command_code <= 2'b10; // RIGHT
            else                  command_code <= 2'b11; // STOP
        end else begin
            command_valid <= 1'b0;
        end
    end

endmodule