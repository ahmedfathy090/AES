module Cipher #(parameter Nk=4,parameter Nr=10) (input [127:0] plainText, output [127:0] encryptedText, input [Nk*32-1:0] key); 

reg [127:0] state;
state = plainText;
wire [127:0] AR_key;

//AddRoundKey #(Nk,Nr) ARK (plainText, key, AR_key);
genvar i;
for (i=0; i< Nr - 1; i=i+1) begin
Round #(Nk,Nr) R1 (state, key, state);
end
EncryptedText=State;
endmodule
