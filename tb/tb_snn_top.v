`timescale 1ns / 1ps

module tb_snn_top;

    reg clk;
    reg rst_n;
    reg [7:0] f0, f1, f2, f3;
    reg feature_valid;

    wire [1:0] command_code;
    wire command_valid;

    integer file_handle;

    snn_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .f0(f0), .f1(f1), .f2(f2), .f3(f3),
        .feature_valid(feature_valid),
        .command_code(command_code),
        .command_valid(command_valid)
    );

    // Clock Generation (100 MHz)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        f0 = 0; f1 = 0; f2 = 0; f3 = 0;
        feature_valid = 0;

        file_handle = $fopen("C:/SNN_Accelerator/results/commands.csv", "w");
        $fwrite(file_handle, "Time_ns,Command_Code\n");

        #20;
        rst_n = 1;
        #20;

        // Test FORWARD
        f0 = 200; f1 = 10; f2 = 10; f3 = 10; feature_valid = 1;
        #10; feature_valid = 0; #50;

        // Test LEFT
        f0 = 10; f1 = 200; f2 = 10; f3 = 10; feature_valid = 1;
        #10; feature_valid = 0; #50;

        // Test RIGHT
        f0 = 10; f1 = 10; f2 = 200; f3 = 10; feature_valid = 1;
        #10; feature_valid = 0; #50;

        // Test STOP
        f0 = 5; f1 = 5; f2 = 5; f3 = 5; feature_valid = 1;
        #10; feature_valid = 0; #50;

        $fclose(file_handle);
        $display("[SUCCESS] Simulation finished! Commands saved to results/commands.csv");
        $finish;
    end

    always @(posedge clk) begin
        if (command_valid) begin
            $fwrite(file_handle, "%0t,%b\n", $time, command_code);
        end
    end

endmodule