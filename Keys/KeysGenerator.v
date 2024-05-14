module KeysGenerator  #(parameter Nk=4, parameter Nr = Nk + 6) (input [0:Nk*32 - 1] key, output [0:128*(Nr+1) - 1] keys);
wire [0: (Nk * 32) * (Nr + 1)-1] allKeys;
assign allKeys [0: Nk*32 - 1] = key;
genvar i;
generate 
  for (i = 1; i < Nr + 1; i = i + 1)  //13
    begin : keyG
      localparam [3:0] count = i;
      key_expansion #(Nk, Nr)  KE (allKeys[(Nk*32)*(i-1)+: Nk*32], allKeys[(Nk*32)*i+: Nk*32], count); 
    end
endgenerate 

assign keys = allKeys[0:128*(Nr+1) - 1] ;

endmodule
// module key_tb;
//     reg [0:127] key128;
//     reg [0:191] key192;
//     reg [0:255] key256;
//     wire [0:128*(10+1) - 1] keys128;
//     wire [0:128*(12+1) - 1] keys192;
//     wire [0:128*(14+1) - 1] keys256;

//     KeysGenerator #(4) KG (key128, keys128);
//     KeysGenerator #(6) KG1 (key192, keys192);
//     KeysGenerator #(8) KG2 (key256, keys256);
//     initial begin
//         key128 = 128'h000102030405060708090a0b0c0d0e0f;
//         $display ("keys: %h", keys128);
//         #100
//         key192 = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;
//         $display ("keys: %h", keys192);
//         #100
//         key256 = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
//         $display ("keys: %h", keys256);
//         #100;
//     end

// endmodule
// module key_expansion_tb;
//     reg [0:127] wIn;
//     wire [0:127] wOut;
//     reg [0:3] roundNum;
//     key_expansion KE (wIn, wOut, roundNum);
//     initial begin
//         wIn = 128'h000102030405060708090a0b0c0d0e0f;
//         roundNum = 4'd1;
//         $display("wOut: %h", wOut);

//     end

// endmodule 
 

