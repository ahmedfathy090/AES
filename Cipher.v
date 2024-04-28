module Cipher #(parameter Nk=4,parameter Nr = Nk + 6) (plainText, keys, encryptedText); 

// Main module parameters
input [127:0] plainText;
input [(Nk*32) * Nr - 1:0] keys; // whole keys
output [127:0] encryptedText;

wire [127:0] state [0:Nr]; // array of (128bit wire) of size Nr
state[0] = plainText; // initial round

AddRoundKey #(Nk,Nr) ARK (state[0], key[(Nk*32) * Nr - 1 -:128], state[1]);
genvar i;
for (i = 1; i < Nr; i = i - 1) begin
Round #(Nk,Nr) encryptionRound (state[i - 1], keys[128*i-:128], state[i]);
end
assign SB_IN = state[Nr - 1];

// Final round
SubBytes S_B (SB_IN, SB_OUT);
shift_rows SR(SB_OUT, SR_OUT);
MixColumns MC(SR_OUT,MC_OUT);

assign encryptedText = MC_OUT;
endmodule
