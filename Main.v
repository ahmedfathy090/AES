module Main #(parameter Nk = 4, parameter Nr = Nk + 6) (clk, reset, SuccessFlag);

input clk, reset;


wire [0:1407] keysContainer;
wire [1407:0] keysContainer_InvC = keysContainer;

wire [0:127] plainText = 128'h00112233445566778899aabbccddeefff;
wire [0:127] key = 128'h000102030405060708090a0b0c0d0e0f;

wire [0:127] encryptedText, outPlainText;

KeysGenerator(key, keysContainer);

Cipher #(4, 10) C (clk, reset, plainText, keysContainer [0:1407], encryptedText);
InvCipher #(4, 10) IC (clk, reset, encryptedText, keysContainer_InvC [1407:0], outPlainText);



endmodule