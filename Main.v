module Main #(parameter Nk = 4, parameter Nr = Nk + 6) (clk, enable,reset, successFlag, Units_seg, Tens_seg, Hunds_seg);

input clk, reset, enable;
output reg successFlag;
output [0:6] Units_seg, Tens_seg, Hunds_seg;

// Store the keys for the encryption & decryption
wire [0:1407] keysContainer;
wire [1407:0] keysContainer_InvC = keysContainer;

wire [0:127] plainText = 128'h00112233445566778899aabbccddeefff;
wire [0:127] key = 128'h000102030405060708090a0b0c0d0e0f;

wire [0:127] encryptedText, outPlainText;
wire [0:127] expectedEncrypt;

reg [0:127] displayedOut;

KeysGenerator(key, keysContainer);

Cipher #(4, 10) C (clk, reset, plainText, keysContainer [0:1407], encryptedText);
InvCipher #(4, 10) IC (clk, reset, encryptedText, keysContainer_InvC [1407:0], outPlainText);

reg [4:0] count = 5'd0;

always @(posedge clk) begin 
    if (reset) begin
        count <= 5'd0;
    end 
    else begin
        if(count <= 10) begin
           displayedOut <= encryptedText;
           
        end
        else if(count <= 21) begin
           displayedOut <= outPlainText;
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

wire [3:0] units, tens, hunds;
reg[3:0] Units_reg, Hunds_reg, Tens_reg;



//convert least significant byte of the state to BCD
BCD_E bcd_encoder(displayedOut[127-:8], units, tens, hunds);

//Display it on seven segment
BCDtoSSD B2S_1 (Units_reg, enable, Units_seg);
BCDtoSSD B2S_2 (Tens_reg, enable, Tens_seg);
BCDtoSSD B2S_3 (Hunds_reg, enable, Hunds_seg);

endmodule