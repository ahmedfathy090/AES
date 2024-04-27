module InvSubBytes #(parameter integer Nb = 4)  (input [127:0] State,output [127:0] Out);

genvar i; // we hade to make it genvar because we are using it in for loop

for (i=0; i< 4*Nb; i=i+1) begin 
InvSBox S1(State[8*i+7:8*i],Out[8*i+7:8*i]);
end 
endmodule 
