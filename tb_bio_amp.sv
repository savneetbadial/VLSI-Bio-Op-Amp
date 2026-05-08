`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2026 12:30:37 PM
// Design Name: 
// Module Name: tb_bio_amp
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


module tb_bio_amp();
    // 1. Signals matching the schematic
    logic [11:0] v_in1; // Voltage of lead
    logic [11:0] v_in2 = 12'd2048; // Set Vin2 to a fixed VS baseline 
    logic [15:0] gain_ad = 16'd50;  // Target Ad from our formulas
    logic [31:0] v_out;

    // 2. Automated file handling for all 48+ patients
    logic [11:0] ecg_memory [0:999];
    string current_file;
    int patient_ids[] = '{100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 
                          111, 112, 113, 114, 115, 116, 117, 118, 119, 
                          121, 122, 123, 124, 200, 201, 202, 203, 205, 
                          207, 208, 209, 210, 212, 213, 214, 215, 217, 
                          219, 220, 221, 222, 223, 228, 230, 231, 232, 
                          233, 234};

    // 3. UUT
    bio_amp uut (.*);

    // 4. Verification Loop
    initial begin
        $display("--- Starting Hardware Verification based on Equations ---");
        
        foreach (patient_ids[p]) begin
            $swrite(current_file, "%0d_ekg.hex", patient_ids[p]);
            $readmemh(current_file, ecg_memory);
            
            $display("[%0t] Processing Patient %s | ISS = 1mA | ID = 0.5mA", $time, current_file);

            for (int i = 0; i < 1000; i++) begin
                v_in1 = ecg_memory[i]; // Load Voltage of lead
                #2777777ns;            // 360Hz sampling
            end
            
            #100ms; // Separation between patient datasets
        end
        $finish;
    end
endmodule
