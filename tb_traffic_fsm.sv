`timescale 1ns / 1ps


module tb_traffic_fsm();


logic clk;
logic rst_n;

traffic_light north, south, east, west; 

light_fsm dut(
	 .clk(clk)
	,.rst_n(rst_n)
	,.north(north)
	,.south(south)
	,.east(east)
	,.west(west)
);


// 초기화 & 리셋 
initial begin
	clk 	= 0;
	rst_n 	= 1;

	#20
	rst_n 	= 0;

	#20
	rst_n 	= 1;
end

// 클럭
always begin
	#5
	clk = ~clk;
end


endmodule