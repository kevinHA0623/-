module full_adder (			             // ������� ��� ����
	input a, b, cin,                             // ��ǲ���� a,b,carry in �� ����
	output s, cout				     // �ƿ�ǲ���� sum, carrry out�� ����
);
	assign s = a ^ b ^ cin;                      // assign�� ���ؼ� sum�� carry out ����
	assign cout = (a & b) | (cin & (a ^ b));    
endmodule                                            // ������� ��� ������ ����
 



module carry_ripple_adder (                         // ĳ�����ð���� ��� ����
	input	[7:0] a, b,                          // ��ǲ���� 8��Ʈ�� a,b�� carry in �� ����, �ƿ�ǲ���� 8��Ʈ�� sum�� carry out�� ����
	input   cin, 
	output 	[7:0] s, 
	output  cout
);


generate                                           // �ݺ����� �����ϴ� ����
	wire [8:0] carry;                          // carry�� 9��Ʈ�� ����(ĳ���� �ø����̹Ƿ�)

	assign carry[0] = cin;                     // carry�� 0��Ʈ���� carry in �̴�.
	assign cout = carry[8];                    // carry out���� carry�� 9��° ��Ʈ�̴�(�ø���?�̹Ƿ�)

	for (genvar i = 0; i < 8; i++) begin      // for genvar�� ���ؼ� ������⸦ ����
		full_adder fa_inst(
			 .a 	(a[i])
			,.b 	(b[i])
			,.cin 	(carry[i])
			,.s 	(s[i])
			,.cout 	(carry[i+1])
		);
	end	
endgenerate

	

endmodule