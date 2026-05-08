`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 12:12:49 PM
// Design Name: 
// Module Name: bio_amp
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


module bio_amp (
    input  logic [11:0] v_in1,  // From data (voltage of lead)
    input  logic [11:0] v_in2,  // Voltage of VS 
    input  logic [15:0] gain_ad, // Simulated Ad = gmc * [Ron || Rop]
    output logic [31:0] v_out   // High precision output for cascaded stages
);

    // Equation: Vid = Vin1 - Vin2
    logic signed [12:0] v_id; 
    
    always_comb begin
        v_id = $signed({1'b0, v_in1}) - $signed({1'b0, v_in2});
        
        // Equation: final amplified signal based on the gain formula
        // This simulates the behavior of the cascode
        v_out = v_id * gain_ad;
    end
    

endmodule