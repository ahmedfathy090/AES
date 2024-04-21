module BCD_E(input clk, input [7:0] in, output reg[3:0] Units, output reg[3:0] Tens, output reg[3:0] Hunds);
wire [3:0] B1,B2,B3,B4,B5,B6,B7;
reg [3:0] B1_S,B2_S,B3_S,B4_S,B5_S,B6_S,B7_S;
reg [4:0] in1;
reg [3:0] in2;
reg [2:0] in3;
reg [1:0] in4;
reg in5,C1toC6_1st,C1toC6_2nd,C2toC6,C6toOut;

ADD3_E C1 ({1'b0,in[7:5]},B1);
ADD3_E C2 ({B1_S[2:0],in1[4]},B2);
ADD3_E C3 ({B2_S[2:0],in2[3]},B3);
ADD3_E C4 ({B3_S[2:0],in3[2]},B4);
ADD3_E C5 ({B4_S[2:0],in4[1]},B5);
ADD3_E C6 ({1'b0,C1toC6_2nd,C2toC6,B3_S[3]},B6);
ADD3_E C7 ({B6_S[2:0],B4_S[3]},B7);

always@(posedge clk)begin
B1_S<=B1;
B2_S<=B2;
B3_S<=B3;
B4_S<=B4;
B5_S<=B5;
B6_S<=B6;
B7_S<=B7;
in1<=in[4:0];
in2<=in1[3:0];
in3<=in2[2:0];
in4<=in3[1:0];
in5<=in4[0];
C1toC6_1st<=B1_S[3];
C1toC6_2nd<=C1toC6_1st;
C2toC6<=B2_S[3];
C6toOut<=B6_S[3];
Units <= {B5_S[2:0],in5};
Tens <= {B7_S[2:0],B5_S[3]};
Hunds <= {1'b0,1'b0,C6toOut,B7_S[3]};


end

endmodule

module ADD3_E(input [3:0] A , output [3:0] B);
reg [3:0] C;
always @ (A)
begin 
     if(A<5)
       begin
          C=A;
       end
     else begin
          C=A+3;  
       end
end
assign B = C;
endmodule