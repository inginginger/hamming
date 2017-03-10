module HammingEnc(
	input clk,
	input rst,
	input [15:0] iData,
	input iValid,// входные данные сопровождаются этим сигналом
	output oReady,
	output [20:0] oData,
	output oValid,// сигнал валидности выходных данных
	input iReady
);
reg [15:0] bufData;
reg [20:0] oBufData;
reg        oBufReady;
reg [1:0] syncValid;
reg [1:0] syncReady;

wire dtctValid = !syncValid[1]&syncValid[0];

reg loc;

always @ (posedge clk) begin
	if(rst || oValid)
		loc <= 0;
	else if (iReady)// ловим сигнал iReady триггером
		loc <= 1;
end

always @ (posedge clk) begin
	oBufReady <= (rst || (oBufReady && loc)) ? 1'b0 : (dtctValid ? 1'b1 : oBufReady);
end

assign oReady = oBufReady;
assign oValid = oReady && loc;

always@(posedge clk) begin
	if(rst) begin
		syncValid <= 2'b0;
		syncReady <= 2'b0;
	end else begin
		syncValid <= {syncValid[0], iValid};
		syncReady <= {syncReady[0], iReady};
	end	
end

always@(posedge clk) begin
	if(rst) 
		bufData <= 16'd0;
	else if(iValid) 
		bufData <= iData;
end

always@(*) begin
	oBufData[0] = bufData[0] ^ bufData[1] ^ bufData[3] ^ bufData[4] ^ bufData[6] ^ bufData[8] ^ bufData[10] ^ bufData[11] ^ bufData[13] ^ bufData[15];
	oBufData[1] = bufData[0] ^ bufData[2] ^ bufData[3] ^ bufData[5] ^ bufData[6] ^ bufData[9] ^ bufData[10] ^ bufData [12] ^ bufData[13];
	oBufData[2] = bufData[0];
	oBufData[3] = bufData[1] ^ bufData[2] ^ bufData[3] ^ bufData[7] ^ bufData[8] ^ bufData[9] ^ bufData[10] ^ bufData[14] ^ bufData[15];
	oBufData[6:4] = bufData[3:1];
	oBufData[7] = bufData[4] ^ bufData[5] ^ bufData[6] ^ bufData[7] ^ bufData[8] ^ bufData[9] ^ bufData[10];
	oBufData[14:8] = bufData[10:4];
	oBufData[15] = bufData[11] ^ bufData[12] ^ bufData[13] ^ bufData[14] ^ bufData[15];
	oBufData[20:16] = bufData[15:11];
end

assign oData  = (iReady) ? oBufData : 21'd0;
endmodule