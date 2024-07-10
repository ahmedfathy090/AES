module BCD_E(input [7:0] in, output [3:0] Units, output [3:0] Tens, output [3:0] Hunds);

wire [3:0] B1,B2,B3,B4,B5,B6,B7;


ADD3_E C1 ({1'b0,in[7:5]},B1);
ADD3_E C2 ({B1[2:0],in[4]},B2);
ADD3_E C3 ({B2[2:0],in[3]},B3);
ADD3_E C4 ({B3[2:0],in[2]},B4);
ADD3_E C5 ({B4[2:0],in[1]},B5);
ADD3_E C6 ({1'b0,B1[3],B2[3],B3[3]},B6);
ADD3_E C7 ({B6[2:0],B4[3]},B7);


assign Units = {B5[2:0],in[0]};

assign Tens = {B7[2:0],B5[3]};

assign Hunds = {1'b0,1'b0,B6[3],B7[3]};

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