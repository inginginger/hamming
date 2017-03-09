module HammingDec(
	input clk,
	input rst,
	input [20:0] iData,
	input iValid,
	output oReady,
	output [15:0] oData,
	output oValid,
	input iReady
);
reg [20:0] bufData;
reg [4:0]  syndrom;
reg        oBufReady;
reg [1:0] syncValid;
reg [20:0] decData;

wire dtctValid = !syncValid[1]&syncValid[0];

always @ (posedge clk) begin
	oBufReady <= (rst || (iReady && oBufReady)) ? 1'b0 : (dtctValid ? 1'b1 : oBufReady);
end

assign oReady = oBufReady;
assign oValid = oReady && iReady;


always@(*) begin
	syndrom[0] = bufData[2] ^ bufData[4] ^ bufData[6] ^ bufData[8] ^ bufData[10] ^ bufData[12] ^ bufData[14] ^ bufData[16] ^ bufData[18] ^  bufData[20];
	syndrom[1] = bufData[2] ^ bufData[5] ^ bufData[6] ^ bufData[9] ^ bufData[10] ^ bufData[13] ^ bufData[14] ^ bufData[17] ^ bufData[18];
	syndrom[2] = bufData[4] ^ bufData[5] ^ bufData[6] ^ bufData[11] ^ bufData[12] ^ bufData[13] ^ bufData[14] ^ bufData[19] ^ bufData[20];
	syndrom[3] = bufData[8] ^ bufData[9] ^ bufData[10] ^ bufData[11] ^ bufData[12] ^ bufData[13] ^ bufData[14];
	syndrom[4] = ^bufData[20:16]; 
end

reg [4:0]position = 0;
always@(*)
position = {syndrom[4] != bufData[15],syndrom[3] != bufData[7],syndrom[2] != bufData[3],syndrom[1] != bufData[1],syndrom[0] != bufData[0]};

wire error = dtctValid && position; 

always@(posedge clk) begin
	if(rst)
		syncValid <= 1'b0;
   else 
		syncValid <= {syncValid[0], iValid};
end

always@(posedge clk) begin
	if(rst)
		decData <= 21'd0;
	else begin
		if(iValid)
			decData <= iData;
		if(error)
			decData[position - 1] <= ~decData[position - 1];			
	end
end

assign oData  = (iReady) ? {decData[20:16], decData[14:8], decData[6:4], decData[2]} : 16'd0;

always@(posedge clk) begin
	if(rst) 
		bufData <= 21'd0;
	else if(iValid) 
		bufData <= iData;
end

endmodule
