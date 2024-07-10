module SubBytes_Test();
    wire [127:0] out;
    reg [127:0] in;
    SubBytes  S1  (in,out);
    initial begin
        $display("Test for 128 bit input");
        in = 128'h00102030405060708090a0b0c0d0e0f0;
        #10;
        if (out != 128'h63cab7040953d051cd60e0e7ba70e18c) // i got this value from searching the internet
            $display("Test failed for 128 bit input the output is %h",out);
        else 
            $display("Test passed for 128 bit input");
        #10;
        in = 128'h89d810e8855ace682d1843d8cb128fe4;
        #10;
        if (out != 128'ha761ca9b97be8b45d8ad1a611fc97369) // i got this value from searching the internet
            $display("Test failed for 128 bit input the output is %h",out);
        else 
            $display("Test passed for 128 bit input");
        #10;
        in= 128'h247240236966b3fa6ed2753288425b6c;
        #10;
        if (out != 128'h36400926f9336d2d9fb59d23c42c3950) // i got this value from searching the internet
            $display("Test failed for 128 bit input the output is %h",out);
        else 
            $display("Test passed for 128 bit input");
        #10;
        in = 128'hcb02818c17d2af9c62aa64428bb25fd7;
        #10;
        if (out != 128'h1f770c64f0b579deaaac432c3d37cf0e) // i got this value from searching the internet
            $display("Test failed for 128 bit input the output is %h",out);
        else 
            $display("Test passed for 128 bit input");
        #10;
    end
endmodule