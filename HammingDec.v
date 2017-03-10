module HammingDec(
	input clk,
	input rst,
	input [20:0] iData,
	input iValid,// входные данные сопровождаются этим сигналом
	output oReady,
	output [15:0] oData,
	output oValid,// сигнал валидности выходных данных
	input iReady
);
reg [20:0] bufData;
reg [4:0]  syndrom;
reg        oBufReady;
reg [1:0] syncValid;
reg [1:0] syncReady;
reg [20:0] decData;
reg delayReady;
reg delayValid;

wire dtctValid = !syncValid[1]&syncValid[0];

reg loc;
always @ (posedge clk) begin
	if(rst || oValid)
		loc <= 0;
	else if (iReady) // ловим сигнал iReady триггером
		loc <= 1;
end

always @ (posedge clk) begin
	oBufReady <= (rst || (oBufReady && loc)) ? 1'b0 : (dtctValid ? 1'b1 : oBufReady);
end

assign oReady = oBufReady;
assign oValid = oReady && loc;

always@(*) begin
	syndrom[0] = bufData[2] ^ bufData[4] ^ bufData[6] ^ bufData[8] ^ bufData[10] ^ bufData[12] ^ bufData[14] ^ bufData[16] ^ bufData[18] ^  bufData[20];
	syndrom[1] = bufData[2] ^ bufData[5] ^ bufData[6] ^ bufData[9] ^ bufData[10] ^ bufData[13] ^ bufData[14] ^ bufData[17] ^ bufData[18];
	syndrom[2] = bufData[4] ^ bufData[5] ^ bufData[6] ^ bufData[11] ^ bufData[12] ^ bufData[13] ^ bufData[14] ^ bufData[19] ^ bufData[20];
	syndrom[3] = bufData[8] ^ bufData[9] ^ bufData[10] ^ bufData[11] ^ bufData[12] ^ bufData[13] ^ bufData[14];
	syndrom[4] = ^bufData[20:16]; 
end

reg [4:0] position = 0;

always@(*)
position = {syndrom[4] != bufData[15],syndrom[3] != bufData[7],syndrom[2] != bufData[3],syndrom[1] != bufData[1],syndrom[0] != bufData[0]};

wire error = dtctValid && position; 

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
		bufData <= 21'd0;
	else if(iValid) 
		bufData <= iData;
end

always@(posedge clk) begin
	if(rst)
		decData <= 21'd0;
	else begin
		if(iValid)
			decData <= iData;
		if(error)
			decData[position - 1] <= ~decData[position - 1];//исправление ошибки			
	end
end

assign oData  = (iReady) ? {decData[20:16], decData[14:8], decData[6:4], decData[2]} : 16'd0;

endmodule
