`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2026 04:19:32 PM
// Design Name: 
// Module Name: qrs_detector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module qrs_detector (
    input  logic clk,
    input  logic reset,
    input  logic [31:0] v_out,     // Amplified signal from bio_amp
    input  logic [31:0] threshold, // The peak value to trigger detection
    output logic heartbeat_pulse   // High when a peak is detected
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            heartbeat_pulse <= 1'b0;
        end else begin
            // If v_out crosses the threshold, we've found the Peak from the graph
            if (v_out >= threshold)
                heartbeat_pulse <= 1'b1;
            else
                heartbeat_pulse <= 1'b0;
        end
    end
endmodule
