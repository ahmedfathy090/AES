module SBox_Test();
wire [7:0] out;
reg [7:0] in;
SBox SBox1 (in,out);

initial begin
    in = 8'hee;
    #10;
    in = 8'h01;
    #10;
    in = 8'hff;
    #10;
    in = 8'h03;
    #10;
    in = 8'h1f;
    #10;
end

initial begin
$monitor("In=%h, Out=%h",in,out);
end
endmodule