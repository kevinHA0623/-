`timescale 1ns / 1ps



module uart_rx #(
	parameter OVERSAMPLE = 32
)(
	input wire rst_n,
	input wire clk,
	
	input logic rx,

	output logic [7:0] fifo_data,
	input wire fifo_full,
	output logic fifo_wr_en,

	output logic err,
	input wire dbg_clk
);


logic [7:0] data;
logic [2:0] idx;
logic [5:0] ovs_cnt;


enum logic [2:0] {
	RESET,
	READY,
	GET_START_BIT,
	GET_DATA,
	GET_STOP_BIT,
	WRITE_FIFO
} state, next_state;


task reset();
	fifo_wr_en 	<= 0;
	fifo_data 	<= 0;
	ovs_cnt 	<= 0;
	err			<= 0;
endtask


task init();
	fifo_wr_en 	<= 0;
	ovs_cnt 	<= 0;
	idx 		<= 0;
endtask


function is_at_middle();
	return ovs_cnt == OVERSAMPLE / 2;
endfunction


function is_at_edge();
	return ovs_cnt == OVERSAMPLE-1;
endfunction



always_comb begin
	next_state = state;

	case(state)
		RESET:	
			next_state = READY;

		READY:	
			if (~rx)
				next_state = GET_START_BIT;

		GET_START_BIT:	
			if (is_at_edge())
				next_state = GET_DATA;

		GET_DATA:
			if ((idx == 7) && is_at_edge())
				next_state = GET_STOP_BIT;

		GET_STOP_BIT:	
			if (is_at_edge())
				next_state = WRITE_FIFO;

		WRITE_FIFO:
			next_state = READY;
	endcase
end


always_ff @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		state 	<= RESET;
	end else begin
		state <= next_state;
	end
end


always_ff @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		reset();
	end else begin
		case (next_state)
			READY: 
				init();

			GET_START_BIT:
				if (is_at_middle())
					if (rx) err <= 1;

			GET_DATA:
				if (is_at_middle()) begin
					data[idx] <= rx;
					idx  <= idx + 1;
				end

			GET_STOP_BIT:
				if (is_at_middle())
					if (!rx) 
						err <= 1;

			WRITE_FIFO: begin
				fifo_wr_en 	<= 1;
				fifo_data 	<= data;
			end
		endcase



		// Oversample 카운터 로직
		case (next_state)
			READY:
				ovs_cnt <= 0;

			default:
				if (is_at_edge())
					ovs_cnt <= 0;
				else
					ovs_cnt <= ovs_cnt + 1;
		endcase
	end
end



ila_rx ila (
	 .clk 		(dbg_clk)
	,.probe0	(rx)
	,.probe1	(idx)
	,.probe2	(data)
	,.probe3	(next_state)
	,.probe4	(ovs_cnt)
	,.probe5 	(clk)
	,.probe6 	(fifo_wr_en)
);

endmodule