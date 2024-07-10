module Round (clk,state, key, roundOut);  // the clk was used to debug the code, it is not used in the final implementation
// Main module parameters
input clk;
input [0:127] state;
input [0 : 127] key;
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

