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
wire [20:0] oEncData; // �������������� ������
wire [15:0] oDecData; // �������������� ������

/*��������� ������ � ���������� �������������� ������ */
assign errData = oEncData^error;  
assign decData = oDecData; 

HammingEnc HammEnc( // �����
  .clk(clk),
  .rst(rst),
  .iData(iData),
  .iValid(iValid),
  .oReady(encReady),
  .oData(oEncData),
  .oValid(encValid),
  .iReady(iReady || decReady)
);

HammingDec HammDec( //�������
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