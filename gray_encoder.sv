module gray_encoder(
  input [7:0] bin,
  output reg [7:0] gray
);


always_comb begin
  for (int i = 0; i < 8; i++) begin
    if (i < 7)
      gray[i] = bin[i+1] ^ bin[i];
    else
      gray[i] = bin[i];
  end
end


endmodule