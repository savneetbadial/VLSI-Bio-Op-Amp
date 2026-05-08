`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2026 04:20:35 PM
// Design Name: 
// Module Name: saturation_check
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


module saturation_check (
    input  logic [31:0] v_out,
    input  logic [31:0] vdd_limit, // Based on our VDD = Peak of graph
    output logic is_saturated
);

    // If the amplified signal hits VDD, the MOSFETs would leave the saturation region
    assign is_saturated = (v_out >= vdd_limit);

endmodule
