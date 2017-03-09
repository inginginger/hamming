`timescale 1ns / 1ps

module EncTb;

	// Inputs
	reg clk;
	reg rst;
	reg [15:0] iData;
	reg iValid;
	reg iReady;

	// Outputs
	wire oReady;
	wire [20:0] oData;
	wire oValid;

	// Instantiate the Unit Under Test (UUT)
	HammingEnc uut (
		.clk(clk), 
		.rst(rst), 
		.iData(iData), 
		.iValid(iValid), 
		.oReady(oReady), 
		.oData(oData), 
		.oValid(oValid), 
		.iReady(iReady)
	);

	initial begin
		// Initialize Inputs
		$display ("Start simulation...");
		rst = 1;
		iData = 16'b0100_0100_0011_1101;
		iValid = 0;
		iReady = 0;

		// Wait 100 ns for global reset to finish
		repeat(10) begin
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

