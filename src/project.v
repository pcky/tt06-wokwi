/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_pckys_game (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;
  assign DI = ui_in;
  assign uo_out = DO;

  reg [7:0] DI,DO;
  
  reg rst;
  assign rst = !rst_n;
    
  reg [7:0] counter;
  reg [7:0] number;
  reg [11:0] counter2;
  reg [2:0] counter3;

  reg [7:0] pattern0;  
  reg [7:0] pattern1;
  reg [7:0] pattern2;
  reg start = 0;
  
  assign DO = (start)?
    ((rst)?pattern1:
    (DI>number)?8'b01000001:
    (DI==number)?pattern2:
    (DI<number)?8'b01001000:
    0):pattern0;

  
  always @(posedge clk )
  begin
    if (rst) begin
        start <= 1;
        number <= counter;
    end
  end

  number_init n_init_inst (clk, rst, counter);
  timer t_inst (clk, counter2, counter3);

assign pattern0 =  
  (counter3 == 0) ? 8'b11010000 :
  (counter3 == 1) ? 8'b11010000 :
  (counter3 == 2) ? 8'b11010000 :
  (counter3 == 3) ? 8'b01010000 :
  (counter3 == 4) ? 8'b01010000 :
                    8'b01010000 ;

assign pattern1 =  
  (counter3 == 0) ? 8'b10100000 :
  (counter3 == 1) ? 8'b00010000 :
  (counter3 == 2) ? 8'b00001000 :
  (counter3 == 3) ? 8'b10000100 :
  (counter3 == 4) ? 8'b00000010 :
                    8'b00000001 ;

assign pattern2 =  
  (counter3 == 0) ? 8'b01000000 :
  (counter3 == 1) ? 8'b01000000 :
  (counter3 == 2) ? 8'b01000000 :
  (counter3 == 3) ? 8'b01001001 :
  (counter3 == 4) ? 8'b01001001 :
                    8'b01001001 ;
  
endmodule

module number_init(
  input clk,
  input rst,
  output [7:0] out
);

  reg [7:0] counter;
  assign out = counter;

  always @(posedge clk )
  begin
    counter <= 0;
    if (rst) begin
        counter <= counter + 1;
    end else begin
    end
  end
endmodule

module timer(input clk, output reg [11:0] counter = 12'h0 + 12'd512, output reg [2:0] counter2 = 0);

    reg flag1 = 0;
    
    always @(posedge clk) begin
        counter <= counter + 1'b1;
      if (counter[9]) begin
        if(counter2 == 6)
                counter2 <= 0;
        if(flag1) begin
          flag1 <= 0;
          if(counter2 == 6)
                counter2 <= 0;
         else
          counter2 <= counter2 + 1;
        end
      end else begin
        flag1 <= 1;
      end
    end
    
endmodule
