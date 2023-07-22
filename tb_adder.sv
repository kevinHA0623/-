`timescale 1ns / 1ps


module tb_adder();

/* DUT 인터페이스 */
logic  	[7:0] a,b; 
logic  	cin;
logic  	[7:0] sum; 
logic 	cout;

/* 테스트 결과 데이터 */ 
int cnt_success;
int cnt_fail;



/************************************** 
*			테스트 입력값
***************************************/
logic [1:0][7:0] test_operands [10] = {
	{8'h00,8'hff},
	{8'h23,8'h45},	
	{8'hff,8'h01},
	{8'hff,8'h02},
	{8'h11,8'h45},
	{8'h42,8'hff},
	{8'h52,8'h23},	
	{8'haa,8'h01},
	{8'hb1,8'h92},
	{8'hc2,8'h48}
};

logic test_cin [10] = {
	0,1,0,1,0,1,0,1,0,1
};



/************************************** 
*		    기대 출력값 (정답)
***************************************/
logic [7:0] sum_golden [10];
logic cout_golden [10];





/************************************** 
*		  DUT (테스트 할 디자인)
***************************************/
carry_ripple_adder dut(
	 .a 	(a)
	,.b 	(b)
	,.cin 	(cin)
	,.s 	(sum)
	,.cout 	(cout)
);



/************************************** 
*		      테스트 진행
***************************************/
initial begin
	$display("*************  Starting Test  **************");

	/* 변수 초기화 */
	a 	= 0;
	b 	= 0;
	cin = 0;
	cnt_success = 0;
	cnt_fail = 0;

	/* 기대 출력값 계산 */
	for (int i = 0; i < 10; i++) begin
		logic [8:0] added =   {1'b0, test_operands[i][0]} 
							+ {1'b0, test_operands[i][1]} 
							+ {8'b0, test_cin[i]};

		sum_golden[i] 	= added[7:0];
		cout_golden[i] 	= added[8];
	end

	/* 테스트 입력값을 넣고 기대값과 출력값 비교 */
	for (int i = 0; i < 10; i++) begin
		a = test_operands[i][1];
		b = test_operands[i][0];
		cin = test_cin[i];

		
		#5	
		$display("[%0d] a = 0x%0h, b = 0x%0h, cin=%b, sum=0x%0h, cout=%0b", i, a, b, cin, sum, cout);
		
		if ((cout == cout_golden[i]) && (sum == sum_golden[i])) begin
			cnt_success++;
		end else begin
			cnt_fail++;
			$display("Error! Expected sum: 0x%0h, Expected cout: 0x%0b", sum_golden[i], cout_golden[i]);
		end
	end

	$display("\nSuccess: %0d\nFail:%0d\n", cnt_success, cnt_fail);
	$finish();
end




endmodule