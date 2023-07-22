`timescale 1ns / 1ps


module tb_gray();



/* DUT 인터페이스 */
reg 	[7:0] enc_in;
wire 	[7:0] enc_out;
wire 	[7:0] dec_in;
wire 	[7:0] dec_out;

/* 테스트 결과 데이터 */ 
int cnt_success;
int cnt_fail;


/* 테스트 입력값 */
logic [7:0] test_bin [10] = {
	8'h00, 8'h01, 8'h02, 8'h03, 8'h04,
	8'h05, 8'h06, 8'h07, 8'h08, 8'h09
};

/* 테스트 기대출력값 */
logic [7:0] golden_gray [10] = {
	8'h00, 8'h01, 8'h03, 8'h02, 8'h06,
	8'h07, 8'h05, 8'h04, 8'h0c, 8'h0d
};



/************************************** 
*		  DUT (테스트 할 디자인)
***************************************/
gray_encoder dut_encoder(
	 .bin(enc_in)
	,.gray(enc_out)
);

gray_decoder dut_decoder(
	 .bin(dec_out)
	,.gray(dec_in)
);

assign dec_in = enc_out; 




/************************************** 
*		      테스트 진행
***************************************/
initial begin
	$display("*************  Starting Test  **************");

	cnt_success = 0;
	cnt_fail = 0;


	for (int i = 0; i < 10; i++) begin
		enc_in = test_bin[i];

		#5
		$display("[%0d], BIN:%8b   GRAY:%8b", i, test_bin[i], enc_out);

		if (enc_out != golden_gray[i]) begin
			$display("Encoder Error. Expected: %8b, Got: %8b", golden_gray[i], enc_out);
			cnt_fail++;
		end
		else if (dec_out != test_bin[i]) begin
			$display("Decoder Error. Expected: %8b, Got: %8b", test_bin[i], dec_out);
			cnt_fail++;
		end
		else begin
			cnt_success++;
		end
	end

	$display("\nSuccess: %0d\nFail:%0d\n", cnt_success, cnt_fail);
	$finish();
end


endmodule