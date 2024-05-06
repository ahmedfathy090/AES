module KeysGenerator  #(parameter Nk=4,parameter Nr = Nk + 6) (input [0:127] key, output [0:(Nk*32) * (Nr + 1) - 1] allKeys);
    assign allKeys[0:127] = key;
     genvar i;
     generate 
        for (i = 1; i < Nr + 1; i = i + 1) 
          begin : keyG
            localparam [3:0] count = i;
            key_expansion KE (allKeys[128*(i-1)+:128], allKeys[128*i+:128], count); 
          end
      endgenerate  
endmodule