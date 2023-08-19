`timescale 1ns / 1ps

module test_mmcm();
//입력
  logic          clk_in1;
  logic          reset;
  
 //출력 
  logic          clk_out1;
  logic          clk_out2;
  logic          clk_out3;
  logic          locked;
     
      
 mmcm_ip mmcm(
  .clk_out1(clk_out1),
  .clk_out2(clk_out2),
  .clk_out3(clk_out3),
  .reset(reset),
  .locked(locked),
  .clk_in1(clk_in1)
 );
 
 initial begin
    clk_in1=0;
    reset=1;
     
    #100
    reset = 0;
 end
 
 
 always begin
    #10
    clk_in1 = ~clk_in1;
   
    
 end 
  
 
 
endmodule
