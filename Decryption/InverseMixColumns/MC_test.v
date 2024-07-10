module MC_Test;
  reg [0:127] in;
  wire [0:127] out;
  
  InvMixColumns InvmixCol(in, out);

  initial begin
    $monitor("input= %H , output= %h",in,out);
    in= 128'h80121e0776fd1d8a8d8c31bc965d1fee;
    #10;
  end
 endmodule
