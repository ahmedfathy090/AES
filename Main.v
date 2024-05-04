module Main #(parameter Nk = 4, parameter Nr = Nk + 6) (clk, enable,reset, successFlag, Units_seg, Tens_seg, Hunds_seg);

input clk, reset, enable;
output reg successFlag = 1'b0;
output [0:6] Units_seg, Tens_seg, Hunds_seg;

// Store the keys for the encryption & decryption
wire [0:1407] keysContainer ;//'= 1408'h000102030405060708090a0b0c0d0e0fd6aa74fdd2af72fadaa678f1d6ab76feb692cf0b643dbdf1be9bc5006830b3feb6ff744ed2c2c9bf6c590cbf0469bf4147f7f7bc95353e03f96c32bcfd058dfd3caaa3e8a99f9deb50f3af57adf622aa5e390f7df7a69296a7553dc10aa31f6b14f9701ae35fe28c440adf4d4ea9c02647438735a41c65b9e016baf4aebf7ad2549932d1f08557681093ed9cbe2c974e13111d7fe3944a17f307a78b4d2b30c5;

wire [1407:0] keysContainer_InvC = keysContainer;

wire [0:127] plainText = 128'h00112233445566778899aabbccddeeff;
wire [0:127] key = 128'h000102030405060708090a0b0c0d0e0f;

wire [0:127] encryptedText, outPlainText;
reg [0:127] encryptedText_reg, outPlainText_reg;
reg C_reset = 1'b0, IC_reset = 1'b0;
wire [0:127] expectedEncrypt;

wire [3:0] units, tens, hunds;
reg[3:0] Units_reg, Hunds_reg, Tens_reg;

reg [0:127] displayedOut;
KeysGenerator KG (key, keysContainer);
Cipher #(4, 10) C (clk, C_reset, plainText, keysContainer [0:1407], encryptedText);

InvCipher #(4, 10) IC (clk, IC_reset, encryptedText_reg, keysContainer_InvC [1407:0], outPlainText);

reg [4:0] count = 5'd0;

always @(posedge clk) begin 
     $display("round out :%h ",encryptedText);
     $display("inround out :%h ",outPlainText);
     $display("count :%d ",count);
     $display("encryptedText :%h ",encryptedText_reg);
     $display("outPlainText :%h ",outPlainText_reg);
    if (reset) begin
        count <= 5'd0;
    end 
    else begin
        if(count <= 10) begin
            C_reset <= 1'b0;
           displayedOut = encryptedText;
        end
        else if(count <= 21) begin
           IC_reset <= 1'b0;
           displayedOut = outPlainText;
           outPlainText_reg = outPlainText;
        end 
        if(count == 10) begin
            IC_reset <= 1'b1;
        end
        if(count == 11) begin
            encryptedText_reg = encryptedText;
        end
        if(count == 21)
        begin
              C_reset <= 1'b1;
              outPlainText_reg = outPlainText;
        end


        Units_reg = units;
        Tens_reg = tens;
        Hunds_reg = hunds;
         count <= count + 1;
        if(count == 11)
            successFlag <= (outPlainText == expectedEncrypt) ? 1'b1:1'b0;
        if(count == 22)
            successFlag <= (displayedOut == plainText) ? 1'b1:1'b0;     
    
        
    end 
end 





//convert least significant byte of the state to BCD
BCD_E bcd_encoder(displayedOut[127-:8], units, tens, hunds);

//Display it on seven segment
BCDtoSSD B2S_1 (Units_reg, enable, Units_seg);
BCDtoSSD B2S_2 (Tens_reg, enable, Tens_seg);
BCDtoSSD B2S_3 (Hunds_reg, enable, Hunds_seg);

endmodule