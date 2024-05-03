module Round #(parameter Nk=4, parameter Nr=10) (state, key, roundOut); 

// Main module parameters
input [0:127] state;
input [0 : 32*Nk -1] key;
output [0:127] roundOut;

// Temp wires
wire [0:127] SB_OUT, SR_OUT, MC_OUT, ARK_OUT;

// Round steps
SubBytes SB (state, SB_OUT);
shift_rows SR(SB_OUT, SR_OUT);
MixColumns MC(SR_OUT,MC_OUT);
AddRoundKey ARK(MC_OUT, key, ARK_OUT);

assign roundOut = ARK_OUT;

endmodule
