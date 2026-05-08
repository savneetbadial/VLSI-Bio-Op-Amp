`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2026 04:21:19 PM
// Design Name: 
// Module Name: bio_system_top
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


module bio_system_top (
    input  logic clk,
    input  logic reset,
    input  logic [11:0] v_in1,      // Voltage of lead 
    input  logic [11:0] v_in2,      // Voltage of VS 
    input  logic [15:0] gain_ad,    // |Ad| = gmc * [Ron || Rop] 
    output logic [31:0] v_out,
    output logic peak_detected,
    output logic warning_clip
);

    // 1. Bio-Amp (Cascaded Differential Stage)
    bio_amp amp_inst (
        .v_in1(v_in1),
        .v_in2(v_in2),
        .gain_ad(gain_ad),
        .v_out(v_out)
    );

    // 2. QRS Peak Detector
    qrs_detector peak_inst (
        .clk(clk),
        .reset(reset),
        .v_out(v_out),
        .threshold(32'd150000), // Adjust based on ECG graph peaks
        .heartbeat_pulse(peak_detected)
    );

    // 3. Headroom/saturation Monitor
    saturation_check clip_inst (
        .v_out(v_out),
        .vdd_limit(32'd200000), // Our calculated VDD limit 
        .is_saturated(warning_clip)
    );
    
endmodule
