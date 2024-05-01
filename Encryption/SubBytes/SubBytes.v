module SubBytes  (input [127:0] State,output [127:0] Out);

genvar i; // we hade to make it genvar because we are using it in for loop
generate 
for (i=0; i< 16; i=i+1) begin  : stateLoop
SBox S1(State[8*i+7:8*i],Out[8*i+7:8*i]);
end 
endgenerate
endmodule 
