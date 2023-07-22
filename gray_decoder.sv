module gray_decoder(
	input [7:0] gray,
	output reg [7:0] bin
);


always_comb begin
	for (int i = 7; i >= 0; i--) begin
		if (i == 7)
			bin[i] = gray[i];
		else
			bin[i] = bin[i+1] ^ gray[i];
	end
end


endmodule