/***************************************
*   Multiplier 모듈
*
*   기능: a * b = product
****************************************/


module multiplier #(
	parameter WIDTH = 8
)(
    input   [WIDTH-1:0] a,
    input   [WIDTH-1:0] b,
    output  [WIDTH*2-1:0] product
);
  
    wire [WIDTH-1:0] partial_sum [WIDTH-1:0];
    wire carry [WIDTH-1:0];

    assign carry[0] = 0;


    generate
        /* col은 세로 위치, row는 가로 위치 */
        for (genvar col = 0; col < WIDTH; col++) begin
            if (col == 0) begin
                for (genvar row = 0; row < WIDTH; row++) begin
                    assign partial_sum[col][row] = a[row] & b[col];
                end 
            end else if (col == 1) begin
                carry_ripple_adder cra (
                     .a    (b[col] ? a : 8'b0) 
                    ,.b    ({1'b0, partial_sum[col-1][WIDTH-1:1]})
                    ,.cin  (1'b0)
                    ,.s    (partial_sum[col])
                    ,.cout (carry[col])
                ); 
            end else begin
                carry_ripple_adder cra (
                     .a    (b[col] ? a : 8'b0) 
                    ,.b    ({carry[col-1], partial_sum[col-1][WIDTH-1:1]})
                    ,.cin  (1'b0)
                    ,.s    (partial_sum[col])
                    ,.cout (carry[col])
                ); 
            end
        end


        for (genvar col = 0; col < WIDTH; col++) begin
            if (col == (WIDTH-1)) begin
                for (genvar row = 0; row < WIDTH; row++) begin
                    assign product[col+row] = partial_sum[col][row];
                end
                assign product[2*WIDTH-1] = carry[col]; 
            end else begin
                assign product[col] = partial_sum[col][0];
            end
        end
    endgenerate

endmodule