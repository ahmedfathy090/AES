module InvCipher #(parameter Nk=4,parameter Nr = Nk + 6) (encryptedText, keys, decryptedText); 

// Main module parameters
input [127:0] encryptedText;
input [(Nk*32) * Nr - 1:0] keys; // whole keys
output [127:0] decryptedText;

// temp parameters
wire [127:0] Inv_SB_IN, Inv_SB_OUT, Inv_SR_OUT, Inv_AR_OUT;
wire [127:0] state [0:Nr]; // array of (128bit wire) of size Nr

// initial round 
AddRoundKey ARK (encryptedText, keys[0+:128], state[0]);

// Loop through all rounds (excluding final round)
genvar i;
generate
for (i = 1; i < Nr; i = i + 1) begin :InvCipherloop
InvRound #(Nk,Nr) encryptionRound (state[i - 1], keys[128*i+:128], state[i]);
end
endgenerate
assign Inv_SB_IN = state[Nr - 1];

// Final round
InvSubBytes SB (Inv_SB_IN, Inv_SB_OUT);
Invshift_rows SR(Inv_SB_OUT, Inv_SR_OUT);
AddRoundKey ARK1 (Inv_SR_OUT, keys[(Nr)*128+:128], Inv_AR_OUT); 

assign decryptedText = Inv_AR_OUT;
endmodule
