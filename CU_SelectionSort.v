module CU_SelectionSort (
	input clk, rst, run, end_load, hit_i, hit_j, end_show,
	output reg swap,
	output reg [2:0] PS
);

	localparam IDLE = 3'b000,
					LOAD = 3'b001,
					ANCHOR = 3'b010,
					FINDMIN = 3'b011,
					SHOW = 3'b100;
	
	reg [1:0] present_state, next_state;
	
	always @ (posedge clk or posedge rst)
	begin
		present_state = (rst == 1) ? IDLE : next_state;
	end
	
	always @ (*)
	begin
		next_state = present_state;
		case(present_state)
		
			// 0
			IDLE: begin
				swap = 0;
				next_state = (run == 1) ? LOAD : IDLE;
			end
			
			// 1
			LOAD: begin
				next_state = (end_load == 1) ? ANCHOR : LOAD;
			end
			
			// 2
			ANCHOR: begin
				next_state = (hit_i == 1) ? SHOW : FINDMIN;
			end
			
			// 3
			FINDMIN: begin
				swap = (hit_j == 1) ? 1 : 0;
				next_state = (hit_j == 1) ? ANCHOR : FINDMIN;
			end
			
			// 4
			SHOW: begin
				next_state = (end_show == 1) ? IDLE : SHOW;
			end
			
			default: begin
				next_state = present_state;
			end
			
		endcase
		PS = present_state;
	end

endmodule