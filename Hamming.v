module Hamming(
  input clk,
  input rst,
  input [15:0] iData,
  input iValid, 
  input iReady,
  input [20:0] error,
  output decValid,
  output [15:0] decData
);

wire [20:0] errData;
//wire decValid;
wire encValid;
wire decReady;
wire encReady;
wire [20:0] oEncData; // закодированные данные
wire [15:0] oDecData; // декодированные данные

/*смешиваем ошибку и полученные закодированные данные */
assign errData = oEncData^error;  
assign decData = oDecData; 

HammingEnc HammEnc( // кодер
  .clk(clk),
  .rst(rst),
  .iData(iData),
  .iValid(iValid),
  .oReady(encReady),
  .oData(oEncData),
  .oValid(encValid),
  .iReady(iReady || decReady)
);

HammingDec HammDec( //декодер
  .clk(clk),
  .rst(rst),
  .iData(errData),
  .iValid(encValid),
  .oReady(decReady),
  .oData(oDecData),
  .oValid(decValid),
  .iReady(encReady)
);

endmodule