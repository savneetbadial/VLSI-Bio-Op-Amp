`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2026 04:24:54 PM
// Design Name: 
// Module Name: tb_bio_system
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

module tb_bio_system();
    // 1. Clock and reset, needed for the QRS Detector
    logic clk = 0;
    logic reset;
    always #5ns clk = ~clk; // Standard 100MHz internal clock

    // 2. Interface signals matching our equations
    logic [11:0] v_in1; // Voltage of lead
    logic [11:0] v_in2 = 12'd2048; // Reference voltage of VS
    logic [15:0] gain_ad = 16'd50; // Ad = gmc * [Ron || Rop]
    logic [31:0] v_out;
    logic peak_detected;
    logic warning_clip;

    // 3. Automated file handling for our 48+ patients
    logic [11:0] ecg_memory [0:999];
    string current_file;
    int patient_ids[] = '{100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 
                          111, 112, 113, 114, 115, 116, 117, 118, 119, 
                          121, 122, 123, 124, 200, 201, 202, 203, 205, 
                          207, 208, 209, 210, 212, 213, 214, 215, 217, 
                          219, 220, 221, 222, 223, 228, 230, 231, 232, 
                          233, 234};

    // 4. Instantiate top system (connects amp, detector, and saturation monitor)
    bio_system_top uut (.*);

    // 5. Verification logic
    initial begin
        // Initialize system
        reset = 1;
        #100ns reset = 0;
        
        $display("--- Starting Hardware Verification based on Schematic Equations ---");
        $display("Design Parameters: ISS = 1mA | ID = 0.5mA | VDD = Peak of Graph");
        
        foreach (patient_ids[p]) begin
            $swrite(current_file, "%0d_ekg.hex", patient_ids[p]);
            
            // Bridges our python-processed data into SystemVerilog memory
            $readmemh(current_file, ecg_memory);
            
            $display("[%0t] Processing Patient %s", $time, current_file);

            for (int i = 0; i < 1000; i++) begin
                v_in1 = ecg_memory[i]; // Inputting voltage of lead
                
                // 360Hz sampling rate delay
                #2777777ns; 
                
                // Monitor for saturation clipping based on our VDD limit
                if (warning_clip) 
                    $display("ALERT: Clipping at sample %0d for %s", i, current_file);
            end
            
            #100ms; // Separation between patient datasets in waveform
        end

        $display("--- Bulk Verification Complete ---");
        $finish;
    end
endmodule
