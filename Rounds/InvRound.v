module InvRound (clk ,state, key, InvRoundOut);

// Main module parameters
input clk;
input [0:127] state;
input [0 : 127]  key;
output [0:127] InvRoundOut;

// Temp wires
wire [0:127] Inv_SB_OUT, Inv_SR_OUT, Inv_MC_OUT, Inv_ARK_OUT;

// Inverse Round steps
Invshift_rows IS_R(state, Inv_SR_OUT);
InvSubBytes IS_B (Inv_SR_OUT, Inv_SB_OUT);
AddRoundKey AR_K(Inv_SB_OUT, key, Inv_ARK_OUT);
InvMixColumns IM_C(Inv_ARK_OUT, Inv_MC_OUT);

assign InvRoundOut = Inv_MC_OUT;

endmodule
