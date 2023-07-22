`timescale 1ns / 1ps


module tb_multiplier();

/* DUT 인터페이스 */
logic [7:0] a, b;
logic [15:0] product;

/* 테스트 결과 데이터 */ 
int cnt_success;
int cnt_fail;


/************************************** 
*		  DUT (테스트 할 디자인)
***************************************/
multiplier #(
	.WIDTH(8)
) dut (
  .a(a),
  .b(b),
  .product(product)
);



/************************************** 
*		      테스트 진행
***************************************/
initial begin
	for (a = 1; a <= 10; a++) begin
		for (b = 1; b <= 10; b++) begin
			#5
			if (product != (a * b)) begin
				$display("[FAIL] a = %d, b = %d, product = %d", a, b, product);
				cnt_fail++;
			end else begin
				$display("[PASS] a = %d, b = %d, product = %d", a, b, product);
				cnt_success++;
			end
		end
	end

	$display("\nSuccess: %0d\nFail:%0d\n", cnt_success, cnt_fail);
	$finish();
end





endmodule