`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2024 14:35:34
// Design Name: 
// Module Name: segment_7
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


module segment_7(
    input clk_100MHz,
    input reset,
    input [3:0] ones,
    input [3:0] tens,
    input [3:0] hundreds,
    input thousands,
    output reg [0:6] seg,       // segment pattern 0-9
    output reg [3:0] digit      // digit select signals
    );
    
    // Parameters for segment patterns
    parameter ZERO  = 7'b000_0001;  // 0
    parameter ONE   = 7'b100_1111;  // 1
    parameter TWO   = 7'b001_0010;  // 2 
    parameter THREE = 7'b000_0110;  // 3
    parameter FOUR  = 7'b100_1100;  // 4
    parameter FIVE  = 7'b010_0100;  // 5
    parameter SIX   = 7'b010_0000;  // 6
    parameter SEVEN = 7'b000_1111;  // 7
    parameter EIGHT = 7'b000_0000;  // 8
    parameter NINE  = 7'b000_0100;  // 9
    parameter NEG   = 7'b111_1110;
    parameter POS   = 7'b111_1111;
    
    // To select each digit in turn
    reg [1:0] digit_select = 0;
    reg [16:0] digit_timer = 0;
    
    always @(posedge clk_100MHz or posedge reset) begin
        if(reset) begin
            digit_select <= 0;
            digit_timer <= 0; 
        end
        else                                        // 1ms x 4 displays = 4ms refresh period
            if(digit_timer == 99_999) begin         // The period of 100MHz clock is 10ns (1/100,000,000 seconds)
                digit_timer <= 0;                   // 10ns x 100,000 = 1ms
                digit_select <=  digit_select + 1;
            end
            else
                digit_timer <=  digit_timer + 1;
    end
    
    // Logic for driving the 4 bit anode output based on digit select
    always @(digit_select) begin
        case(digit_select) 
            2'b00 : digit = 4'b1110;   // Turn on ones digit
            2'b01 : digit = 4'b1101;   // Turn on tens digit
            2'b10 : digit = 4'b1011;   // Turn on hundreds digit
            2'b11 : digit = 4'b0111;   // Turn on thousands digit
        endcase
    end
    
    // Logic for driving segments based on which digit is selected and the value of each digit
    always @(*)
        case(digit_select)
            2'b00 : begin       // ONES DIGIT
                        case(ones)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end
                    
            2'b01 : begin       // TENS DIGIT
                        case(tens)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end
                    
            2'b10 : begin       // HUNDREDS DIGIT
                        case(hundreds)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                        endcase
                    end
                    
            2'b11 : begin       // MINUTES ONES DIGIT
                        case(thousands)
                            1'b0 : seg = POS;
                            1'b1 : seg = NEG;
                        endcase
                    end
        endcase

endmodule

module divider(input clk,[8:0] y, output reg [11:0] d = 0, output reg sign = 0);
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