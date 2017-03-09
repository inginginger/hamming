`timescale 1ns / 1ps

module HammingTb;

	// Inputs
	reg clk;
	reg rst;
	reg [15:0] iData;
	reg iValid; 
	reg iReady;
	reg [20:0] error;
	// Outputs
	wire [15:0] decData;
	wire decValid;

	// Instantiate the Unit Under Test (UUT)
	Hamming uut(
	  .clk(clk),
	  .rst(rst),
	  .iData(iData),
	  .iValid(iValid),
	  .iReady(iReady), 
	  .error(error),
	  .decValid(decValid),
	  .decData(decData)
	);


	reg [4:0] bitError;
	initial begin
		// Initialize Inputs
		$display("Start simulation...");
		rst = 1;
		iData = 16'b0100_0100_0011_1101;
		iValid = 0;
		error = 21'd32;
		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
		#100
		iValid = 1;
		#20
		iValid = 0;
		// Add stimulus here
		#100
		iReady = 1;
		#100
		iReady = 0;
		// Add stimulus here
		#80
		repeat(10) begin
			iValid = 0;
			#20
			iValid = 1;
			#20
			iValid = 0;
			#80
			$display("Ended cycle");
		end	
		#100
		$display("Ended simulation");
		$stop;
		
	end
	
	initial begin
		clk = 0;
		forever
		#10 clk = ~clk;
   end
      
endmodule