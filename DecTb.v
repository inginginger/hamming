`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:27:25 03/08/2017
// Design Name:   hammingEnc
// Module Name:   C:/ISE14_7/hamming/tb_enc.v
// Project Name:  hamming
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: hammingEnc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DecTb;

	// Inputs
	reg clk;
	reg rst;
	reg [20:0] iData;
	reg iValid;
	reg iReady;

	// Outputs
	wire oReady;
	wire [15:0] oData;
	wire oValid;

	// Instantiate the Unit Under Test (UUT)
	HammingDec uut (
		.clk(clk), 
		.rst(rst), 
		.iData(iData), 
		.iValid(iValid), 
		.oReady(oReady), 
		.oData(oData), 
		.oValid(oValid), 
		.iReady(iReady)
	);


reg [4:0] bitError;

	initial begin
		// Initialize Inputs
		$display("Start simulation...");
		rst = 1;
		iData = 21'h08c3e6;
		iValid = 0;
		iReady = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
		#100
		iValid = 1;
		#20
		iValid = 0;
		// Add stimulus here
		#70
		iReady = 1;
		#20
		
		repeat(100) begin
			bitError = ($random)%21;
			iData[bitError] = ~iData[bitError];
			iValid = 0;
			iReady = 0;
			#20
			iValid = 1;
			#20
			iValid = 0;
			#60
			iReady = 1;
			#20
			if(oData == 16'h443d)//check
				$display ("Data decoded");
			else
				$display (oData,"Error");
			iData = 21'h08c3e6;	
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