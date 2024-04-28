module Cipher #(parameter Nk=4,parameter Nr = Nk + 6) (plainText, keys, encryptedText); 

// Main module parameters
input [127:0] plainText;
input [(Nk*32) * Nr - 1:0] keys; // whole keys
output [127:0] encryptedText;

// temp parameters
wire SB_IN, SB_OUT, SR_OUT, MC_OUT;
wire [127:0] state [0:Nr]; // array of (128bit wire) of size Nr

// initial round 
AddRoundKey ARK (plainText, key[0+:128], state[0]);

// Loop through all rounds (excluding final round)
genvar i;
for (i = 1; i < Nr; i = i + 1) begin 
Round #(Nk,Nr) encryptionRound (state[i - 1], keys[128*i+:128], state[i]);
end
assign SB_IN = state[Nr - 1];

// Final round
SubBytes SB (SB_IN, SB_OUT);
shift_rows SR(SB_OUT, SR_OUT);
MixColumns MC(SR_OUT,MC_OUT);

assign encryptedText = MC_OUT;
endmodule
