`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2024 05:21:53
// Design Name: 
// Module Name: freq_analyser
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


module FFTAnalyzer(
    input signed [15:0] fft_real, // Real part of FFT output bin
    input signed [15:0] fft_imag, // Imaginary part of FFT output bin
    output integer frequency       // Output frequency of the input signal
);

reg [15:0] peak_magnitude = 0;
reg [9:0] peak_bin_index = 0;
parameter integer N = 1024;    // FFT size (default value)
parameter integer Fs = 1000;   // Sampling frequency (default value)
integer i, mag;

always @* begin
    // Find the peak bin
    peak_magnitude = 0;
    peak_bin_index = 0;
    for (i = 0; i < N; i = i + 1) begin
        // Calculate magnitude
        mag = fft_real*fft_real + fft_imag*fft_imag;
        if (mag > peak_magnitude) begin
            peak_magnitude = mag;
            peak_bin_index = i;
        end
    end
    // Calculate frequency
    assign frequency = peak_bin_index * (Fs / N);
end

endmodule


module divider1(input clk,[8:0] y, output reg [11:0] d = 0, output reg sign = 0);
    reg [7:0] temp1, temp2;

    always @(posedge clk)
    begin
        temp1 = y[7:0];
        temp2 = ~y[7:0] + 1;
        
        if (y[8] == 0)
        begin
            sign <= y[8];
            d[3:0] <= temp1 % 4'd10;
            d[7:4] <= (temp1/10) % 10;
            d[11:8] <= (temp1/100);
        end
        else
        begin
            sign <= y[8];
            d[3:0] <= temp2 % 4'd10;
            d[7:4] <= (temp2/10) % 10;
            d[11:8] <= (temp2/100);
        end
    end
endmodule