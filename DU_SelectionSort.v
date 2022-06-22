
module DU_SelectionSort #(parameter N = 5, bitwidth = 8) (
	input clk, rst, run,
	input [bitwidth-1:0] val_in,
	output reg [bitwidth-1:0] val_out,
	output reg end_load, hit_i, hit_j, end_show,
	output reg [7:0] addr,
	output reg [3:0] i, j,
	output reg [2:0] PS
);

	reg swap;
	
	reg [bitwidth-1:0] temp;
	reg [bitwidth-1:0] memory_block [0:255];
	reg [3:0] min_index;	
	
	integer k;
	always @ (posedge clk, posedge rst)
	begin
		if (rst == 1) begin
			val_out <= 0;
			end_load <= 0;
			hit_i <= 0;
			hit_j <= 0;
			end_show <= 0;
			addr <= 0;
			i <= 0;
			j <= 0;
		end
		else begin
			case(PS)
			
				// IDLE
				0: begin
					i <= 0;
					j <= 0;
					addr <= 0;
				end
				
				// LOAD
				1: begin
					if (addr < N) begin
						end_load <= 0;
						memory_block[addr] <= val_in;
						addr <= addr + 1;
					end
					else begin
						end_load <= 1;
						addr <= 0;
					end
				end
				
				// ANCHOR
				2: begin
					if (i < N-2) begin
						hit_i <= 0;
						min_index <= i;
					end
					else begin
						hit_i <= 1;
					end
				end
				
				// FINDMIN
				3: begin
					if (j < N -1) begin
						hit_j <= 0;
						if (memory_block[j] < memory_block[min_index]) begin
							min_index = j;
						end
						j <= j + 1;
					end
					else begin
						hit_j <= 1;
						i <= i + 1;
						j <= i + 1;
						if (swap == 1) begin
							temp <= memory_block[i];
							memory_block[i] <= memory_block[min_index];
							memory_block[min_index] <= temp;
						end
					end
				end
				
				// SHOW
				4: begin
					if (addr < N) begin
						end_show <= 0;
						val_out <= memory_block[addr];
						addr <= addr + 1;
					end
					else begin
						end_show <= 1;
						addr <= 0;
					end
				end
				
			endcase
		end
	end
		
endmodule