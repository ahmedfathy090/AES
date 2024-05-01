module Cipher #(parameter Nk=4,parameter Nr = Nk + 6) (plainText, keys, encryptedText, roundOutreg); 

// Main module parameters
input [127:0] plainText;
input [(Nk*32) * Nr - 1:0] keys; // whole keys
output [127:0] encryptedText;
output reg [0:(Nr+1)*128-1] roundOutreg ;

// temp parameters
wire [127:0] SB_IN, SB_OUT, SR_OUT;
wire [127:0] state [0:Nr]; // array of (128bit wire) of size Nr

// initial round 
AddRoundKey ARK (plainText, keys[0+:128], state[0]);
initial
roundOutreg[0:128] = state[0];
// Loop through all rounds (excluding final round)
genvar i;
generate
for (i = 1; i < Nr; i = i + 1) begin : Cipherloop
Round #(Nk,Nr) encryptionRound (state[i - 1], keys[128*i+:128], state[i]);
end
endgenerate
integer j;

assign SB_IN = state[Nr - 1];

// Final round
SubBytes SB (SB_IN, SB_OUT);
shift_rows SR(SB_OUT, SR_OUT);
AddRoundKey ARK1 (SR_OUT, keys[(Nr-1)*128+:128], state[Nr]);

assign encryptedText = state[Nr];

// Store all the states to be printed
initial begin
    for (j = 0; j <= Nr; j = j + 1) begin
       roundOutreg[128*j+:128] = state[j];
     end
end
endmodule