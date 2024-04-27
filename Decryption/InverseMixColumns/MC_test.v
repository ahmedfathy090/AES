module MC_Test;
  reg [0:127] in;
  wire [0:127] out;
  
  InvMixColumns mixCol(in, out);
  initial begin
   $monitor("input= %H , output= %h",in,out);
   in= 128'h627bceb9999d5aaac945ecf423f56da5;
   #10;
 end
 endmodule
